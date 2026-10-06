install_base() {
  log_info "INSTALLATION"

  log_step "Selecting mirrors"
  reflector \
    --connection-timeout 60 \
    --download-timeout 60 \
    --country "$MIRROR_COUNTRIES" \
    --latest 10 \
    --protocol https \
    --sort rate \
    --save /etc/pacman.d/mirrorlist

  log_step "Installing packages"
  local attempt
  for ((attempt = 1; attempt <= PACSTRAP_ATTEMPTS; attempt++)); do
    if pacstrap -K "$MOUNT_POINT" "${PACKAGES[@]}"; then
      break
    fi

    ((attempt < PACSTRAP_ATTEMPTS)) ||
      die "pacstrap failed after $PACSTRAP_ATTEMPTS attempts"
    log_warning "pacstrap failed (attempt $attempt/$PACSTRAP_ATTEMPTS), retrying in ${PACSTRAP_RETRY_DELAY}s..."
    sleep "$PACSTRAP_RETRY_DELAY"
  done
  echo
}
