#!/bin/sh
#
# NAME
#        umount-image.sh - Unmount image files
#
# SYNOPSIS
#        ./umount-image.sh PATH...
#
# DESCRIPTION
#        See mount-image.sh for documentation.
#
# COPYRIGHT AND LICENSE
#        Copyright (C) 2008-2011 Victor Engmark
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

    # Remove shortcut
    if [ -L "$link_path" ]
    then
        gksudo --description "$description" -- \
        rm -- "$link_path" || \
            warning "Couldn't remove symbolic link '${link_path}'."
    fi

    # Abort if the file is already unmounted
    if [ ! -d "$image_mount_path" ]
    then
        warning "'${image_path}' is not mounted."
        continue
    fi

    # Unmount file
    gksudo --description "$description" -- \
    umount -- "$image_mount_path" || \
        error "Couldn't unmount '${image_mount_path}'." $EX_OSERR

    # Remove mount directory
    if [ -d "$image_mount_path" ]
    then
        gksudo --description "$description" -- \
        rmdir -- "$image_mount_path" || \
            warning "Couldn't remove mount directory '${image_mount_path}'."
    fi
done
