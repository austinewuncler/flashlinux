configure_system() {
	local chroot_dir="$MOUNT_POINT/root/$CHROOT_DIR_NAME"

  log_info "SYSTEM CONFIGURATION"

  log_step "Generating fstab"
  genfstab -U "$MOUNT_POINT" | tee --append "$MOUNT_POINT/etc/fstab"

  log_step "Chrooting into the new environment"
  cp --recursive "$SCRIPT_DIR/$CHROOT_DIR_NAME" "$chroot_dir"
  chmod +x "$chroot_dir/$CHROOT_ENTRY"
  install --mode 644 "$SHIM_SIGNED_PATH/$SHIM_EFI" "$MOUNT_POINT/root/$SHIM_EFI"
  install --mode 644 "$SHIM_SIGNED_PATH/$MM_EFI" "$MOUNT_POINT/root/$MM_EFI"
  arch-chroot -S "$MOUNT_POINT" "/root/$CHROOT_DIR_NAME/$CHROOT_ENTRY" "$TARGET_HOSTNAME" "$USERNAME"
  rm -rf "$chroot_dir"
  rm -f "$MOUNT_POINT/root/$SHIM_EFI"
  rm -f "$MOUNT_POINT/root/$MM_EFI"

  umount --force --recursive "$MOUNT_POINT"
}
