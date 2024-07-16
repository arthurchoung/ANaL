#!/bin/bash

if [ "x$1" = "x" ]; then
	echo "Specify disk, boot partition, and UUID for system partition"
	exit 1
fi
DISKDEVICE="$1"

if [ "x$2" = "x" ]; then
	echo "Specify disk, boot partition, and UUID for system partition"
	exit 1
fi
BOOTDEVICE="$2"

if [ "x$3" = "x" ]; then
	echo "Specify disk, boot partition, and UUID for system partition"
	exit 1
fi
UUID="$3"

MOUNTPOINT="/mntbootloader"
if ! [ -d "$MOUNTPOINT" ]; then
    echo "Error, $MOUNTPOINT either does not exist or is not a directory"
    exit 1
fi

# check if MOUNTPOINT is mounted or not, must be unmounted
if findmnt "$MOUNTPOINT" >/dev/null; then
	echo "Error, $MOUNTPOINT is already mounted"
	exit 1
fi

# check if BOOTDEVICE is mounted or not, must be unmounted
if findmnt "$BOOTDEVICE" >/dev/null; then
	echo "Error, $BOOTDEVICE is already mounted"
	exit 1
fi

# check if partition is vfat
if ! blkid -s TYPE -o value "$BOOTDEVICE" | grep '^vfat$' >/dev/null ; then
    echo "Error, partition is not formatted as vfat"
    exit 1
fi

# Let the user format the partition
#mkfs.vfat "$BOOTDEVICE"

if ! syslinux -i "$BOOTDEVICE" ; then
    echo "Error, unable to install syslinux"
    exit 1
fi

if ! mount "$BOOTDEVICE" "$MOUNTPOINT" ; then
    echo "Error, unable to mount $BOOTDEVICE (perhaps needs to be formatted)"
    exit 1
fi

cp /mntinstaller/InstallerMBRBootloader/* "$MOUNTPOINT"
sed -i "s/__UUID__/$UUID/g" "$MOUNTPOINT/syslinux.cfg"

umount "$MOUNTPOINT"

dd bs=440 count=1 conv=notrunc if=/usr/share/syslinux/mbr.bin of="$DISKDEVICE"

