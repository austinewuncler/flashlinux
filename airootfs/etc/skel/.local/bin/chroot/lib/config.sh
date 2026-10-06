readonly TIMEZONE="Africa/Nairobi"
readonly LOCALE="en_US.UTF-8"
readonly CONSOLE_FONT="ter-132n"

readonly PACKAGES=(
  base-devel
  bluez
  bluez-utils
  btrfs-progs
  fish
  git
  intel-ucode
  networkmanager
  refind
  terminus-font
  tuned
  tuned-ppd
)

readonly PACMAN_CONF="/etc/pacman.conf"
readonly PACMAN_OPTIONS=(Color VerbosePkgLists)
readonly PACMAN_RETRY_DELAY=5
readonly PACMAN_ATTEMPTS=3

readonly SHIM_FILE="/root/shimx64.efi"

readonly REFIND_DIR="/boot/EFI/refind"
readonly REFIND_THEME_REPO="https://github.com/catppuccin/refind.git"
readonly REFIND_THEME_INCLUDE="themes/catppuccin/mocha.conf"
readonly KERNEL_CMDLINE="rw rootflags=subvol=@ rootfstype=btrfs"

TARGET_HOSTNAME=""
USERNAME=""

