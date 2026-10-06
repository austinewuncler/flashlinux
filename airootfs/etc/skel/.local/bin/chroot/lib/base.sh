configure_time() {
  ln --force --symbolic "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
  hwclock --systohc
  systemctl enable systemd-timesyncd
}

configure_locale() {
  sed --in-place "s/^#$LOCALE/$LOCALE/" /etc/locale.gen
  locale-gen

  echo "LANG=$LOCALE" >/etc/locale.conf
  echo "FONT=$CONSOLE_FONT" >/etc/vconsole.conf
}

configure_network() {
  echo "$TARGET_HOSTNAME" >/etc/hostname

  echo
  echo
}

build_initramfs() {
  mkinitcpio -P
}
