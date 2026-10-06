readonly MOUNT_POINT="/mnt"

readonly BOOT_LABEL="ARCH"
readonly ROOT_LABEL="root"
readonly DATA_LABEL="data"

readonly BOOT_END="500MiB"
readonly ROOT_END="50GiB"

readonly BTRFS_OPTIONS="compress=zstd,noatime"
readonly MIRROR_COUNTRIES="Kenya,South Africa"

readonly PACSTRAP_ATTEMPTS=3
readonly PACSTRAP_RETRY_DELAY=5

readonly PACKAGES=(base linux linux-firmware)
readonly ROOT_SUBVOLUMES=(@ @home @var_cache @var_log)
readonly DATA_SUBVOLUMES=(@data @data_appdata @data_downloads @data_media)

readonly CHROOT_DIR_NAME="chroot"
readonly CHROOT_ENTRY="chroot.sh"
readonly SHIM_EFI="shimx64.efi"
readonly MM_EFI="mmx64.efi"

DISK=""
TARGET_HOSTNAME=""
USERNAME=""
BOOT_PARTITION=""
ROOT_PARTITION=""
DATA_PARTITION=""
