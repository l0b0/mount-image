`mount-image`
=============

Easy mounting of ISO (and similar) files, from Nautilus or the shell.

Install
-------

    git clone https://github.com/l0b0/mount-image.git
    sudo make -C mount-image install

Now you can remove the `mount-image` directory.

Run
---

In *Nautilus*, right-click on one or more files, then select *Mount Image File(s)* or *Unmount Image File(s)*.

In the *shell*:

    mount-image *.{iso,nrg}
    umount-image *.{iso,nrg}
