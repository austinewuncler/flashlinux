function configure_mirrors
    log_step "Generating mirror list for '$MIRROR_COUNTRIES'..."

    command --query reflector
    or fail_and_exit "'reflector' is not installed on this live system."

    set --local tmp (mktemp)

    reflector --country "$MIRROR_COUNTRIES" --protocol https --age 48 --sort rate --save "$tmp"
    or begin
        rm --force "$tmp"
        fail_and_exit "reflector failed to generate a mirror list."
    end

    grep --quiet '^Server' "$tmp"
    or begin
        rm --force "$tmp"
        fail_and_exit "reflector found no mirrors for '$MIRROR_COUNTRIES'."
    end

    run install --mode 644 "$tmp" /etc/pacman.d/mirrorlist
    rm --force "$tmp"

    log_success "Mirror list updated."
end

function install_base
    log_step "Installing base system ($BASE_PACKAGES $EXTRA_PACKAGES)..."

    run pacstrap -K "$MOUNT_POINT" $BASE_PACKAGES $EXTRA_PACKAGES

    log_success "Base system installed."
end

function generate_fstab
    set --local fstab "$MOUNT_POINT/etc/fstab"

    log_step "Generating fstab..."

    genfstab -U "$MOUNT_POINT" >"$fstab"
    or fail_and_exit "genfstab failed."

    grep --quiet '^UUID=' "$fstab"
    or fail_and_exit "Generated fstab has no entries: '$fstab'."

    log_success "Wrote '$fstab'."
end
