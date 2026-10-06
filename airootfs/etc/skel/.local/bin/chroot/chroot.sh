#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: ${0##*/} <hostname> <username>" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR

source "$SCRIPT_DIR/lib/config.sh"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/packages.sh"
source "$SCRIPT_DIR/lib/base.sh"
source "$SCRIPT_DIR/lib/users.sh"
source "$SCRIPT_DIR/lib/bootloader.sh"

main() {
  TARGET_HOSTNAME=$1
  USERNAME=$2

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
}

main "$@"
