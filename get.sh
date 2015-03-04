#!/bin/bash
#wget http://xecdesign.com/downloads/linux-qemu/kernel-qemu
wget http://downloads.raspberrypi.org/raspbian_latest
unzip raspbian_latest && rm raspbian_latest
set -x
loopdev=`sudo losetup -f`
img=`echo *.img`
offset=`file $img | grep -oh 'startsector [^,]*' | tail -n 1 | cut -d' ' -f2`
offset=$(($offset*512))
mntdir=mnt
sudo mkdir -p $mntdir
sudo chown root:root $mntdir
sudo losetup --offset $offset $loopdev $img
sudo mount $loopdev $mntdir
sudo bash -c "echo > $mntdir/etc/ld.so.preload"
sudo cp 90-qemu.rules $mntdir/etc/udev/rules.d
sudo umount $mntdir
sudo losetup -d $loopdev
