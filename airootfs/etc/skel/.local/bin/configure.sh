#!/usr/bin/env bash
#
# configure.sh: configure a freshly bootstrapped Arch Linux system.
# Runs inside the new system via arch-chroot (see flash-install).
#
# Usage: configure.sh <hostname>

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: ${0##*/} <hostname> <username>" >&2
  exit 1
fi

# --- Configuration -----------------------------------------------------------

readonly TARGET_HOSTNAME="$1"
readonly USERNAME="$2"

readonly TIMEZONE="Africa/Nairobi"
readonly LOCALE="en_US.UTF-8"
readonly CONSOLE_FONT="ter-132n"

readonly PACKAGES=(
  base-devel
  btrfs-progs
  fish
  git
  intel-ucode
  networkmanager
  refind
  terminus-font
)

readonly PACMAN_CONF="/etc/pacman.conf"
readonly PACMAN_OPTIONS=(Color VerbosePkgLists)

readonly REFIND_DIR="/boot/EFI/refind"
readonly REFIND_THEME_REPO="https://github.com/catppuccin/refind.git"
readonly REFIND_THEME_INCLUDE="themes/catppuccin/mocha.conf"
readonly KERNEL_CMDLINE="rw rootflags=subvol=@ rootfstype=btrfs"

# --- Helpers -----------------------------------------------------------------

log_heading() {
  echo
  echo "==> $1"
}

# --- Steps -------------------------------------------------------------------

configure_pacman() {
  local option

  for option in "${PACMAN_OPTIONS[@]}"; do
    sed --in-place "s/^#$option/$option/" "$PACMAN_CONF"
  done
}

install_packages() {
  pacman -S --noconfirm "${PACKAGES[@]}"
}

configure_time() {
  ln --force --symbolic "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
  hwclock --systohc
  systemctl enable systemd-timesyncd
}

# Must run before build_initramfs so the console font ends up in the initramfs.
configure_locale() {
  sed --in-place "s/^#$LOCALE/$LOCALE/" /etc/locale.gen
  locale-gen

  echo "LANG=$LOCALE" >/etc/locale.conf
  echo "FONT=$CONSOLE_FONT" >/etc/vconsole.conf
}

configure_network() {
  echo "$TARGET_HOSTNAME" >/etc/hostname

  echo
  systemctl enable NetworkManager
  echo
}

build_initramfs() {
  mkinitcpio -P
}

set_root_password() {
  log_heading "Setting password for root"
  passwd
}

create_user() {
  useradd --create-home --groups wheel --shell "$(command -v fish)" "$USERNAME"

  log_heading "Setting password for user '$USERNAME'"
  passwd "$USERNAME"
}

configure_sudo() {
  local file="/etc/sudoers.d/wheel"

  echo "%wheel ALL=(ALL:ALL) ALL" >"$file"
  chmod 440 "$file"
  visudo --check --file "$file"
}

install_bootloader() {
  local partuuid
  partuuid="$(findmnt --noheadings --output PARTUUID /)"

  refind-install

  printf '"Arch Linux" "root=PARTUUID=%s %s"\n' "$partuuid" "$KERNEL_CMDLINE" >/boot/refind_linux.conf

  git clone "$REFIND_THEME_REPO" "$REFIND_DIR/themes/catppuccin" --depth 1
  echo "include $REFIND_THEME_INCLUDE" >>"$REFIND_DIR/refind.conf"
}


# --- Main --------------------------------------------------------------------

main() {
  configure_pacman
  install_packages

  configure_time
  configure_locale
  configure_network
  build_initramfs

  set_root_password
  create_user
  configure_sudo

  install_bootloader
  exit 0
}

main
