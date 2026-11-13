function release_mount
    set --local gnupg "$MOUNT_POINT/etc/pacman.d/gnupg"

    test -d "$gnupg"
    and gpgconf --homedir "$gnupg" --kill all 2>/dev/null

    return 0
end

function cleanup
    if test "$MOUNTED" = true
        log_warning "Unmounting '$MOUNT_POINT'..."

        for path in $TEMP_PATHS
            rm -rf -- "$path"
        end
        set -g TEMP_PATHS
        release_mount
        umount --recursive "$MOUNT_POINT" 2>/dev/null
        set --global MOUNTED false
    end
end

function fail_and_exit
    log_error "$argv"
    cleanup
    exit 1
end

function run
    $argv
    or fail_and_exit "Command failed: $argv"
end

function usage
    echo "Usage: $SCRIPT_NAME [-h|--help] <disk> <hostname> <username>"
end

function partition_path --argument-names disk number
    if string match --quiet --regex '\d$' -- "$disk"
        echo "$disk"p"$number"
    else
        echo "$disk""$number"
    end
end

function confirm --argument-names prompt
    read --prompt-str (set_color --bold yellow)"$prompt [y/N] "(set_color normal) reply
    contains -- "$reply" y Y yes YES Yes
end

function chroot_run
    run arch-chroot "$MOUNT_POINT" $argv
end

function write_file --argument-names path
    printf '%s\n' $argv[2..-1] >"$path"
    or fail_and_exit "Could not write '$path'."
end

function set_password --argument-names user
    while not arch-chroot "$MOUNT_POINT" passwd "$user"
        log_warning "Password for '$user' was not set. Try again."
    end
end
