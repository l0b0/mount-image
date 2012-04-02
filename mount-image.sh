#!/bin/sh
#
# NAME
#        mount-image.sh - Mount image files
#
# SYNOPSIS
#        ./mount-image.sh PATH...
#
# DESCRIPTION
#        A PATH consists of a DIRNAME and a BASENAME, where BASENAME can be
#        split into FILENAME and EXTENSION. Given these, the script will
#        attempt to mount PATH as /media/BASENAME, and create a symlink
#        DIRNAME/FILENAME. In other words, there will be a symlink with the
#        same path as the image file, except for the EXTENSION.
#
#        umount-image.sh undoes these actions, in the opposite sequence.
#
#        If either script fails, it is likely that the image or mount point is
#        still in use, or that the image file has no extension.
#
# COPYRIGHT AND LICENSE
#        Copyright (C) 2008-2012 Victor Engmark
#
#        This program is free software: you can redistribute it and/or modify
#        it under the terms of the GNU General Public License as published by
#        the Free Software Foundation, either version 3 of the License, or
#        (at your option) any later version.
#
#        This program is distributed in the hope that it will be useful,
#        but WITHOUT ANY WARRANTY; without even the implied warranty of
#        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#        GNU General Public License for more details.
#
#        You should have received a copy of the GNU General Public License
#        along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
################################################################################

directory="$(dirname -- "$(readlink -f -- "$0")")"
. "${directory}/common.sh" || exit $EX_UNKNOWN

for image_path
do
    setup $1 || continue

    # Create mount directory
    if [ ! -d "$image_mount_path" ]
    then
        gksudo --description "$description" -- \
        mkdir -p -- "$image_mount_path" || \
            error "Couldn't create mount directory '${image_mount_path}'." \
            $EX_CANTCREAT
    fi

    # Skip if the file is already mounted
    if [ -n "$(ls -A -- "$image_mount_path")" ]
    then
        warning "'${image_path}' is already mounted at '${image_mount_path}'."
        continue
    fi

    # Mount file
    gksudo --description "$description" -- \
    mount -o loop -t iso9660 "$image_path" "$image_mount_path" || \
        error "Couldn't mount '${image_path}' at '${image_mount_path}'." \
        $EX_SOFTWARE

    # Create shortcut from the ISO location
    if [ ! -e "$link_path" ]
    then
        gksudo --description "$description" -- \
        ln -s "$image_mount_path" "$link_path" || \
            error "Couldn't create symbolic link '${link_path}'." \
            $EX_CANTCREAT
    fi
done
