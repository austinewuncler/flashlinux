function validate_names --argument-names target_hostname username
    log_step "Checking the hostname and username..."

    string match --quiet --regex '^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$' -- "$target_hostname"
    or fail_and_exit "Invalid hostname '$target_hostname' (use lowercase letters, digits and hyphens)."

    string match --quiet --regex '^[a-z_][a-z0-9_-]{0,31}$' -- "$username"
    or fail_and_exit "Invalid username '$username' (use lowercase letters, digits, '_' and '-')."

    test "$username" != root
    or fail_and_exit "The username must not be 'root'; root is configured separately."

    log_success "Hostname '$target_hostname' and username '$username' are valid."
end

function validate_secure_boot
    test "$SECURE_BOOT" = true
    or return 0

    log_step "Checking the Secure Boot settings..."

    string match --quiet --regex '^[a-z0-9@._+-]+$' -- "$SHIM_AUR_PACKAGE"
    or fail_and_exit "Invalid SHIM_AUR_PACKAGE '$SHIM_AUR_PACKAGE'."

    log_success "Secure Boot via '$SHIM_AUR_PACKAGE' (AUR) is enabled."
end

function check_uefi
    log_step "Checking the boot mode..."

    test -d /sys/firmware/efi/efivars
    or fail_and_exit "Not booted in UEFI mode; rEFInd cannot be installed."

    log_success "Booted in UEFI mode."
end

function validate_disk --argument-names disk
    log_step "Checking the disk '$disk'..."

    test -b "$disk"
    or fail_and_exit "'$disk' is not a block device. Check 'lsblk'."

    test (lsblk --nodeps --noheadings --output TYPE "$disk") = disk
    or fail_and_exit "'$disk' is not a whole disk (pass e.g. /dev/nvme0n1, not /dev/nvme0n1p1)."

    set --local in_use (lsblk --noheadings --raw --output MOUNTPOINTS "$disk" | string match --regex --invert '^$')
    test (count $in_use) -eq 0
    or fail_and_exit "'$disk' has mounted partitions ($in_use). Unmount them first."

    mountpoint --quiet "$MOUNT_POINT"
    and fail_and_exit "'$MOUNT_POINT' is already a mount point. Unmount it first."

    log_success "Disk '$disk' is usable."
end

function check_network
    log_step "Checking internet connectivity..."

    ping -c1 -W2 ping.archlinux.org &>/dev/null
    or fail_and_exit "No internet connectivity. Connect first (iwctl)."

    log_success "Connected."
end

function sync_clock
    log_step "Enabling network time synchronisation..."

    run timedatectl set-ntp true

    log_success "System clock will be kept in sync."
end

function confirm_wipe --argument-names disk
    log_warning "ALL DATA on '$disk' will be destroyed:"

    lsblk --output NAME,SIZE,MODEL,FSTYPE,LABEL "$disk"

    read --prompt-str (set_color --bold yellow)"Type '$disk' to confirm: "(set_color normal) reply

    test "$reply" = "$disk"
    or fail_and_exit "Aborted."
end
