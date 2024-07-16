#!/bin/bash

if [ "x$1" = "x" ]; then
	echo "Specify boot partition and UUID for system partition"
	exit 1
fi
BOOTDEVICE="$1"

if [ "x$2" = "x" ]; then
	echo "Specify boot partition and UUID for system partition"
	exit 1
fi
UUID="$2"

# check if mountpoint is a directory
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

if ! mount "$BOOTDEVICE" "$MOUNTPOINT" ; then
    echo "Error, unable to mount $BOOTDEVICE (perhaps needs to be formatted)"
    exit 1
fi

cp -R -T /mntinstaller/InstallerEFIBootloader "$MOUNTPOINT"
sed -i "s/__UUID__/$UUID/g" "$MOUNTPOINT/EFI/BOOT/syslinux.cfg"

umount "$MOUNTPOINT"

