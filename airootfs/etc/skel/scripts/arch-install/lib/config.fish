set --global BOOT_LABEL ARCH
set --global ROOT_LABEL root
set --global BOOT_SIZE 512MiB
set --global MOUNT_POINT /mnt
set --global BTRFS_OPTS compress=zstd,noatime

set --global MIRROR_COUNTRIES KE,ZA

set --global BASE_PACKAGES base linux linux-firmware
set --global EXTRA_PACKAGES base-devel btrfs-progs networkmanager neovim refind intel-ucode fish git sbsigntools mokutil openssl

set --global TIMEZONE Africa/Nairobi
set --global LOCALE en_US.UTF-8
set --global USER_SHELL (command -v fish)
set --global DEFAULT_EDITOR nvim
set --global SERVICES NetworkManager.service systemd-timesyncd.service fstrim.timer

set --global SECURE_BOOT true
set --global SHIM_AUR_PACKAGE shim-signed-bin
set --global SHIM_AUR_REF ""

set --global TEMP_PATHS

set --global REFIND_THEME_REPO https://github.com/blackma9ick/refind.git
set --global REFIND_THEME_REF c0bf9f7af28b258bde543eaaf39b0efea693a369

set --global SUBVOLUMES \
    @:/ \
    @data:/data \
    @home:/home \
    @var_cache:/var/cache \
    @var_log:/var/log

set --global ICON_HEADER \Uf04d8
set --global ICON_STEP \Uf04d7
set --global ICON_SUCCESS \Uf05e0
set --global ICON_ERROR \uf057
set --global ICON_WARNING \uf071

set --global MOUNTED false
