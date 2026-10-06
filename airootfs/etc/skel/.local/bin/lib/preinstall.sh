check_internet() {
  log_step "Checking internet connection"

  ping -c1 -W2 ping.archlinux.org &>/dev/null ||
    die "There's no internet connection. Run 'sudo nmtui'."
}

check_clock() {
  log_step "Updating the system clock"
  echo
  timedatectl
  echo
}

check_disk() {
  [[ -b $DISK ]] || die "$DISK does not exist. Check 'lsblk'."
}

confirm_wipe() {
  log_warning "About to WIPE $DISK"
  echo
  lsblk "$DISK"
  echo
  confirm "Type 'yes' to continue:" || die "Aborted"
  echo
}
