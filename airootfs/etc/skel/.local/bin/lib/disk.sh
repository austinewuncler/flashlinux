partition_disk() {
  log_step "Partitioning $DISK"

  wipefs --all --quiet "$DISK"

  parted --script "$DISK" \
    mklabel gpt \
    mkpart "$BOOT_LABEL" fat32 1MiB "$BOOT_END" \
    set 1 esp on \
    mkpart "$ROOT_LABEL" btrfs "$BOOT_END" "$ROOT_END" \
    mkpart "$DATA_LABEL" btrfs "$ROOT_END" 100%

  partprobe "$DISK"
  udevadm settle
}

resolve_partitions() {
  local prefix=$DISK

  if [[ $DISK == *[0-9] ]]; then
    prefix+="p"
  fi

  BOOT_PARTITION="${prefix}1"
  ROOT_PARTITION="${prefix}2"
  DATA_PARTITION="${prefix}3"
}

format_partitions() {
  log_step "Formatting partitions"

  mkfs.fat -F32 -n "$BOOT_LABEL" "$BOOT_PARTITION" >/dev/null
  mkfs.btrfs --force --quiet --label "$ROOT_LABEL" "$ROOT_PARTITION"
  mkfs.btrfs --force --quiet --label "$DATA_LABEL" "$DATA_PARTITION"
}
