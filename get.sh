#!/bin/bash
set -x -e

#wget http://xecdesign.com/downloads/linux-qemu/kernel-qemu

wget downloads.raspberrypi.org/raspbian/images/raspbian-2015-02-17/2015-02-16-raspbian-wheezy.zip
unzip 2015-02-16-raspbian-wheezy.zip && rm 2015-02-16-raspbian-wheezy.zip

loopdev=`sudo losetup -f`
img=`echo *.img`
offset=62914560
echo $offset
mntdir=mnt
sudo mkdir -p $mntdir
sudo chown root:root $mntdir
sudo losetup --offset $offset $loopdev $img
sudo mount $loopdev $mntdir
sudo bash -c "echo > $mntdir/etc/ld.so.preload"
sudo cp 90-qemu.rules $mntdir/etc/udev/rules.d
sudo umount $mntdir
sudo losetup -d $loopdev
