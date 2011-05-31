#!/bin/sh
fail()
{
    echo 'Installation failed! Please submit a bug report at' >&2
    echo 'https://github.com/l0b0/mount-image/issues' >&2
    echo 'with a copy of the output.' >&2
    exit 1
}

# Get directory of this script
full_path="$(readlink -fn -- "$0")" || fail
dir="$(dirname -- "$full_path")" || fail

# Install Nautilus Actions
sudo apt-get install nautilus-actions || fail

# Move files in place
sudo cp -- "${dir}/common.sh" "${dir}/mount-image" "${dir}/umount-image" /usr/local/bin || fail

# Make the scripts executable
sudo chmod a+x -- /usr/local/bin/mount-image /usr/local/bin/umount-image || fail

# Import the Nautilus settings (run for each user)
gconftool-2 --load "${dir}/nautilus-actions.xml" || fail

# Success
echo 'Installation succeeded. Please see the README file for usage instructions.'
