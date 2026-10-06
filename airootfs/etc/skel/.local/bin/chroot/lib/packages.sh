configure_pacman() {
  local option

  for option in "${PACMAN_OPTIONS[@]}"; do
    sed --in-place "s/^#$option/$option/" "$PACMAN_CONF"
  done
}

install_packages() {
	local attempt

	for ((attempt = 1; attempt <= PACMAN_ATTEMPTS; attempt++)); do
		if pacman -S --noconfirm "${PACKAGES[@]}"; then
			break
		fi

		((attempt < PACMAN_ATTEMPTS)) ||
			die "pacstrap failed after $PACMAN_ATTEMPTS attempts"

		log_warning "pacstrap failed (attempt $attempt/$PACMAN_ATTEMPTS), retrying in ${PACMAN_RETRY_DELAY}s..."
		sleep "$PACMAN_RETRY_DELAY"
	done
	
	systemctl enable NetworkManager.service
	systemctl enable bluetooth.service
	systemctl enable tuned.service
	systemctl enable tuned-ppd.service
}
