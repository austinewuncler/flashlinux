install_bootloader() {
  local partuuid
  partuuid="$(findmnt --noheadings --output PARTUUID /)"

  refind-install --shim "$SHIM_FILE"

  printf '"Arch Linux" "root=PARTUUID=%s %s"\n' "$partuuid" "$KERNEL_CMDLINE" >/boot/refind_linux.conf

  git clone "$REFIND_THEME_REPO" "$REFIND_DIR/themes/catppuccin" --depth 1
  echo "include $REFIND_THEME_INCLUDE" >>"$REFIND_DIR/refind.conf"
}
