create_subvolumes() {
  local partition=$1 name
  shift

  log_step "Creating subvolumes on $partition"
  mount "$partition" "$MOUNT_POINT"
  for name in "$@"; do
    btrfs subvolume create "$MOUNT_POINT/$name"
  done
  umount "$MOUNT_POINT"
}

mount_subvolume() {
  mount --mkdir --options "$BTRFS_OPTIONS,subvol=$2" "$1" "$MOUNT_POINT$3"
}

cleanup() {
  umount --recursive "$MOUNT_POINT" &>/dev/null || true
}

mount_filesystems() {
  trap cleanup EXIT

  log_step "Mounting file systems"

  create_subvolumes "$ROOT_PARTITION" "${ROOT_SUBVOLUMES[@]}"
  create_subvolumes "$DATA_PARTITION" "${DATA_SUBVOLUMES[@]}"

  log_step "Mounting btrfs subvolumes with options"

  mount_subvolume "$ROOT_PARTITION" @ ""
  mount_subvolume "$ROOT_PARTITION" @home /home
  mount_subvolume "$ROOT_PARTITION" @var_cache /var/cache
  mount_subvolume "$ROOT_PARTITION" @var_log /var/log
  mount_subvolume "$DATA_PARTITION" @data /data
  mount_subvolume "$DATA_PARTITION" @data_appdata /data/appdata
  mount_subvolume "$DATA_PARTITION" @data_downloads /data/downloads
  mount_subvolume "$DATA_PARTITION" @data_media /data/media

  log_step "Mounting boot partition"
  mount --mkdir "$BOOT_PARTITION" "$MOUNT_POINT/boot"
  echo
}
