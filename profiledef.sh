#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="flashlinux"
iso_label="FLASH_LINUX_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Austine Wuncler"
iso_application="Flash Linux ISO"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="flashlinux"
bootmodes=('uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="erofs"
airootfs_image_tool_options=('-zlzma,109' -E 'ztailpacking')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/skel/.local/bin/bootstrap-arch"]="0:0:700"
)
