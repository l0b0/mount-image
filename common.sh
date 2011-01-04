cmdname="$(basename -- "$0")"

description="mount-image"

mount_dir='/media'

# Exit codes from /usr/include/sysexits.h, as recommended by
# http://www.faqs.org/docs/abs/HTML/exitcodes.html
EX_SOFTWARE=70    # internal software error
EX_OSERR=71       # system error (e.g., can't fork)
EX_CANTCREAT=73   # can't create (user) output file

# Custom errors
EX_UNKNOWN=1

error()
{
    zenity --error --title "$description" --text "$1"
    exit ${2:-$EX_UNKNOWN}
}

warning()
{
    zenity --warning --title "$description" --text "$1"
}

is_image()
{
    if [ -z "$(file -b -- "$1" | grep 'ISO 9660\|UDF filesystem')" ]
    then
        warning "'${1}' appears not to be an image file. Skipping."
        return 1
    fi
}

setup()
{
    # Check the file type before continuing
    if ! is_image "$image_path"
    then
        return 1
    fi

    image_filename="$(basename -- "$image_path")"

    image_mount_path="${mount_dir}/${image_filename}"

    link_path="$(dirname -- "$image_path")/${image_filename%.*}"
}
