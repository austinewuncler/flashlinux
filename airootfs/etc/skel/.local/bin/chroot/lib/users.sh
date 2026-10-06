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
