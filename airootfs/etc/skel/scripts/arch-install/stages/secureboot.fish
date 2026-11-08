function install_shim --argument-names username
    set --local pkg "$SHIM_AUR_PACKAGE"
    set --local aur_dir /var/tmp/aur-build
    set --local host_dir "$MOUNT_POINT$aur_dir"
    set --local sudoers "$MOUNT_POINT/etc/sudoers.d/99-aur-build"
    set --local as_user runuser -u "$username" -- env HOME="/home/$username"

    log_step "Fetching the AUR package '$pkg'..."

    set --global TEMP_PATHS "$host_dir" "$sudoers"
    run rm --recursive --force "$host_dir"
    chroot_run $as_user mkdir --parents "$aur_dir"
    chroot_run $as_user git clone --quiet "https://aur.archlinux.org/$pkg.git" "$aur_dir/$pkg"
    if test -n "$SHIM_AUR_REF"
        chroot_run $as_user git -C "$aur_dir/$pkg" checkout --quiet "$SHIM_AUR_REF"
    end

    log_warning "AUR packages are unvetted. This PKGBUILD runs as '$username' and its output is installed as root:"
    cat "$host_dir/$pkg/PKGBUILD"
    confirm "Build and install '$pkg'?"
    or fail_and_exit "Aborted: '$pkg' was not approved."

    log_step "Building '$pkg'..."
    write_file "$sudoers" "$username ALL=(root) NOPASSWD: /usr/bin/pacman"
    run chmod 440 "$sudoers"
    chroot_run $as_user env --chdir="$aur_dir/$pkg" makepkg --syncdeps --install --noconfirm

    rm --recursive --force -- "$host_dir" "$sudoers"
    set --global TEMP_PATHS
    log_success "Installed '$pkg'."
end

function locate_shim
    set -l shim (arch-chroot "$MOUNT_POINT" pacman -Qlq "$SHIM_AUR_PACKAGE" | string match --regex '^/.*/shimx64\.efi$')
    test (count $shim) -eq 1
    or fail_and_exit "Could not find shimx64.efi in the files of '$SHIM_AUR_PACKAGE'."

    set --local dir (dirname "$shim")
    test -e "$MOUNT_POINT$dir/mmx64.efi"; or test -e "$MOUNT_POINT$dir/MokManager.efi"
    or fail_and_exit "No MokManager (mmx64.efi) next to '$shim'."

    set --global SHIM_PATH "$shim"
end

function setup_kernel_signing
    log_step "Setting up kernel signing for Secure Boot..."

    set --local keys /etc/refind.d/keys
    for key_file in refind_local.key refind_local.crt refind_local.cer
        test -f "$MOUNT_POINT$keys/$key_file"
        or fail_and_exit "'$keys/$key_file' is missing; did refind-install --localkeys run?"
    end

    run mkdir --parents "$MOUNT_POINT/usr/local/bin" "$MOUNT_POINT/etc/pacman.d/hooks"
    write_file "$MOUNT_POINT/usr/local/bin/refind-sign-kernels" \
        '#!/bin/sh' \
        '# Sign every kernel on the ESP with the local MOK key. Safe to re-run.' \
        'set -eu' \
        'key=/etc/refind.d/keys/refind_local.key' \
        'crt=/etc/refind.d/keys/refind_local.crt' \
        'for kernel in /boot/vmlinuz-*; do' \
        '    [ -e "$kernel" ] || continue' \
        '    if sbverify --cert "$crt" "$kernel" >/dev/null 2>&1; then continue; fi' \
        '    sbsign --key "$key" --cert "$crt" --output "$kernel.signed" "$kernel"' \
        '    mv "$kernel.signed" "$kernel"' \
        done
    run chmod 755 "$MOUNT_POINT/usr/local/bin/refind-sign-kernels"

    write_file "$MOUNT_POINT/etc/pacman.d/hooks/95-refind-sign-kernels.hook" \
        '[Trigger]' \
        'Operation = Install' \
        'Operation = Upgrade' \
        'Type = Path' \
        'Target = usr/lib/modules/*/vmlinuz' \
        '' \
        '[Action]' \
        'Description = Signing kernels for Secure Boot...' \
        'When = PostTransaction' \
        'Depends = sbsigntools' \
        'Exec = /usr/local/bin/refind-sign-kernels'

    chroot_run /usr/local/bin/refind-sign-kernels
    chroot_run sbverify --cert "$keys/refind_local.crt" /boot/vmlinuz-linux
    log_success "Kernel signed; a pacman hook will re-sign future kernels."
end

function enroll_mok
    log_step "Queueing the signing key for MOK enrollment..."
    arch-chroot "$MOUNT_POINT" mokutil --import /etc/refind.d/keys/refind_local.cer --root-pw
    and log_success "Key queued for enrollment."
    or log_warning "mokutil could not queue the key. At first boot choose 'Enroll key from disk' and select EFI/refind/keys/refind_local.cer."
end

function print_secure_boot_steps
    log_warning "Secure Boot: finish setup at the first boot"
    echo "  1. MokManager appears: Enroll MOK -> Continue -> Yes -> enter the ROOT password -> Reboot."
    echo "  2. Enter the firmware setup and enable Secure Boot."
    echo "  If MokManager does not appear: Enroll key from disk -> EFI/refind/keys/refind_local.cer."
end
