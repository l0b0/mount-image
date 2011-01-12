#!/bin/sh
fail()
{
    echo 'Installation failed! Please submit a bug report at'
    echo 'https://github.com/l0b0/mount-image/issues'
    echo 'with a copy of the output.'
    exit 1
}

# Get directory of this script
full_path="$(readlink -fn -- "$0")" || fail
dir="$(dirname -- "$full_path")" || fail

# Move files in place
cp -v -- "${dir}/common.sh" "${dir}/mount-image" "${dir}/umount-image" /usr/local/bin || fail

# Make the scripts executable
chmod a+x -- /usr/local/bin/mount-image /usr/local/bin/umount-image || fail

# Import the Nautilus settings (run for each user)
gconftool-2 --load mount-image/nautilus-actions/* || fail

# Success
echo 'Installation succeeded. Please see the README file for usage instructions.'
