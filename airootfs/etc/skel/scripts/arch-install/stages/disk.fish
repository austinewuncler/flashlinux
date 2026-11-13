function partition_disk --argument-names disk
    log_step "Partitioning '$disk'..."

    run wipefs --all --quiet "$disk"
    run parted --script "$disk" \
        mklabel gpt \
        mkpart "$BOOT_LABEL" fat32 1MiB "$BOOT_SIZE" \
        set 1 esp on \
        mkpart "$ROOT_LABEL" btrfs "$BOOT_SIZE" 100%
    run partprobe "$disk"
    run udevadm settle

    log_success "Partitioned '$disk'."
end

function format_partitions --argument-names disk
    set --local boot (partition_path "$disk" 1)
    set --local root (partition_path "$disk" 2)

    log_step "Formatting the partitions..."

    run wipefs --all --quiet "$boot" "$root"

    run mkfs.fat -F32 -n "$BOOT_LABEL" "$boot"
    log_success "Formatted '$boot'."

    run mkfs.btrfs --quiet --label "$ROOT_LABEL" "$root"
    log_success "Formatted '$root'."
end

function mount_filesystems --argument-names disk
    set --local boot (partition_path "$disk" 1)
    set --local root (partition_path "$disk" 2)

    log_step "Creating Btrfs subvolumes..."

    set --global MOUNTED true
    run mount "$root" "$MOUNT_POINT"

    for entry in $SUBVOLUMES
        set --local subvolume (string split --max 1 : "$entry")[1]
        run btrfs subvolume create "$MOUNT_POINT/$subvolume"
    end

    run umount "$MOUNT_POINT"

    log_step "Mounting the file systems..."

    for entry in $SUBVOLUMES
        set --local parts (string split --max 1 : "$entry")
        run mount --mkdir -o "$BTRFS_OPTS,subvol=$parts[1]" "$root" "$MOUNT_POINT$parts[2]"
    end

    run mount --mkdir --options umask=0077 "$boot" "$MOUNT_POINT/boot"

    log_success "File systems mounted under '$MOUNT_POINT'."
end

function unmount_filesystems
    log_step "Unmounting '$MOUNT_POINT'..."

    sync
    release_mount

    if umount --recursive "$MOUNT_POINT"
        set --global MOUNTED false
        log_success "Unmounted '$MOUNT_POINT'."

        return
    end

    log_error "'$MOUNT_POINT' is still busy. Processes using it:"

    command --query fuser
    and fuser --verbose --mount "$MOUNT_POINT" >&2

    log_error "Stop them (and leave '$MOUNT_POINT' if your shell is inside it), then run: umount --recursive $MOUNT_POINT"

    exit 1
end
