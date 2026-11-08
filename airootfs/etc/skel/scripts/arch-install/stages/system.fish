function configure_time_and_locale --argument-names target_hostname
    log_step "Configuring timezone, clock and locale..."

    test -e "$MOUNT_POINT/usr/share/zoneinfo/$TIMEZONE"
    or fail_and_exit "Unknown timezone '$TIMEZONE'."
    chroot_run ln --symbolic --force "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
    chroot_run hwclock --systohc

    run sed --in-place "s/^#\($LOCALE \)/\1/" "$MOUNT_POINT/etc/locale.gen"
    grep --quiet "^$LOCALE " "$MOUNT_POINT/etc/locale.gen"
    or fail_and_exit "Locale '$LOCALE' not found in locale.gen."
    chroot_run locale-gen
    write_file "$MOUNT_POINT/etc/locale.conf" "LANG=$LOCALE"

    write_file "$MOUNT_POINT/etc/hostname" "$target_hostname"
    log_success "Time, locale and hostname configured."
end

function configure_editor
    log_step "Setting the default editor to '$DEFAULT_EDITOR'..."
    test -x "$MOUNT_POINT/usr/bin/$DEFAULT_EDITOR"
    or fail_and_exit "Editor '$DEFAULT_EDITOR' is not installed in the new system."
    write_file "$MOUNT_POINT/etc/environment" \
        "EDITOR=$DEFAULT_EDITOR" \
        "VISUAL=$DEFAULT_EDITOR"
    log_success "Default editor set."
end

function install_bootloader --argument-names root_partition username
    log_step "Installing rEFInd..."

    set --local uuid (blkid --match-tag UUID --output value "$root_partition")
    test -n "$uuid"
    or fail_and_exit "Could not read the UUID of '$root_partition'."

    if test "$SECURE_BOOT" = true
        install_shim "$username"
        locate_shim
        chroot_run refind-install --yes --shim "$SHIM_PATH" --localkeys
        setup_kernel_signing
    else
        chroot_run refind-install
    end

    set --local options "root=UUID=$uuid rootflags=subvol=@ rw initrd=/intel-ucode.img initrd=/initramfs-linux.img"
    test -e "$MOUNT_POINT/boot/intel-ucode.img"
    or fail_and_exit "intel-ucode.img is missing from the ESP."
    write_file "$MOUNT_POINT/boot/refind_linux.conf" \
        "\"Boot with standard options\" \"$options\"" \
        "\"Boot to single-user mode\" \"$options single\""
    log_success "Bootloader installed."
end

function install_refind_theme
    log_step "Installing the Rosé Pine rEFInd theme ($REFIND_THEME_VARIANT)..."

    set --local refind_dir "$MOUNT_POINT/boot/EFI/refind"
    set --local theme_dir "$refind_dir/rose-pine"
    set --local include_line "include rose-pine/theme.conf"

    test -f "$refind_dir/refind.conf"
    or fail_and_exit "'$refind_dir/refind.conf' not found; was rEFInd installed?"

    set --local tmp (mktemp --directory)
    git -C "$tmp" init --quiet
    and git -C "$tmp" fetch --quiet --depth 1 "$REFIND_THEME_REPO" "$REFIND_THEME_REF"
    and git -C "$tmp" checkout --quiet FETCH_HEAD
    or begin
        rm --recursive --force "$tmp"
        fail_and_exit "Could not fetch the theme from '$REFIND_THEME_REPO' at '$REFIND_THEME_REF'."
    end

    run rm --recursive --force "$theme_dir"
    run mkdir --parents "$theme_dir"
    run cp --recursive "$tmp/background" "$tmp/icons" "$tmp/selection" \
        "$tmp/theme.conf" "$tmp/license" "$tmp/acknowledgments" "$theme_dir/"
    rm --recursive --force "$tmp"

    if test "$REFIND_THEME_VARIANT" != main
        run sed --in-place \
            -e "s|background/solid-main\.png|background/solid-$REFIND_THEME_VARIANT.png|" \
            -e "s|icons/main-color|icons/$REFIND_THEME_VARIANT-color|" \
            -e "s|selection/main-|selection/$REFIND_THEME_VARIANT-|" \
            "$theme_dir/theme.conf"
    end
    for asset in (string match --regex --groups-only '^(?:banner|icons_dir|selection_big|selection_small) (\S+)' <"$theme_dir/theme.conf")
        test -e "$refind_dir/$asset"
        or fail_and_exit "Theme asset '$asset' is missing after install."
    end

    grep --quiet --line-regexp --fixed-strings "$include_line" "$refind_dir/refind.conf"
    or printf '\n%s\n' "$include_line" >>"$refind_dir/refind.conf"
    log_success "Theme installed."
end

function enable_services
    log_step "Enabling services ($SERVICES)..."
    chroot_run systemctl enable $SERVICES
    log_success "Services enabled."
end

function configure_accounts --argument-names username
    log_step "Setting the root password..."
    set_password root

    log_step "Creating user '$username'..."
    test -x "$MOUNT_POINT$USER_SHELL"
    or fail_and_exit "Shell '$USER_SHELL' is not installed in the new system."
    grep --quiet --line-regexp --fixed-strings "$USER_SHELL" "$MOUNT_POINT/etc/shells"
    or printf '%s\n' "$USER_SHELL" >>"$MOUNT_POINT/etc/shells"
    chroot_run useradd --create-home --groups wheel --shell "$USER_SHELL" "$username"
    write_file "$MOUNT_POINT/etc/sudoers.d/10-wheel" "%wheel ALL=(ALL:ALL) ALL"
    run chmod 440 "$MOUNT_POINT/etc/sudoers.d/10-wheel"
    set_password "$username"
    log_success "Accounts configured."
end

function configure_system --argument-names disk target_hostname username
    configure_time_and_locale "$target_hostname"
    configure_editor
    configure_accounts "$username"
    install_bootloader (partition_path "$disk" 2) "$username"
    install_refind_theme
    enable_services
    if test "$SECURE_BOOT" = true
        enroll_mok
    end
end

function enter_chroot
    command --query arch-chroot
    or fail_and_exit "'arch-chroot' is not available (install arch-install-scripts)."

    log_step "Entering the new system. Type 'exit' (or press Ctrl-D) when you are done."
    arch-chroot "$MOUNT_POINT"
    or log_warning "The chroot shell exited with status $status."
    log_success "Left the chroot."
end
