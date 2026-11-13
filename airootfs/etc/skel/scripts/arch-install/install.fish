#!/usr/bin/env fish

if test (id --user) -ne 0
    exec sudo -- (realpath (status filename)) $argv
end

set --global SCRIPT_NAME (basename (status filename))
set --global SCRIPT_DIR (dirname (realpath (status filename)))

for module in \
    lib/config lib/log lib/helpers \
    stages/preflight stages/disk stages/base stages/system stages/secureboot
    source "$SCRIPT_DIR/$module.fish"
end

function main
    argparse --name "$SCRIPT_NAME" h/help -- $argv; or begin
        usage >&2
        exit 2
    end

    if set --query _flag_help
        usage
        exit 0
    end

    if test (count $argv) -ne 3
        usage >&2
        exit 2
    end

    set --local disk (realpath -- "$argv[1]" 2>/dev/null; or echo "$argv[1]")
    set --local target_hostname "$argv[2]"
    set --local username "$argv[3]"

    log_header PRE-INSTALLATION

    validate_names "$target_hostname" "$username"
    validate_secure_boot
    check_uefi
    validate_disk "$disk"
    check_network
    sync_clock
    confirm_wipe "$disk"
    partition_disk "$disk"
    format_partitions "$disk"
    mount_filesystems "$disk"
    configure_mirrors
    install_base
    generate_fstab
    configure_system "$disk" "$target_hostname" "$username"
    enter_chroot
    unmount_filesystems

    log_success "Done. You can reboot now."

    if test "$SECURE_BOOT" = true
        print_secure_boot_steps
    end
end

main $argv
