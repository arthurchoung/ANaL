#!/bin/bash

if [ "x$1" = "x" ]; then
    echo "Specify install disk device, boot partition, and system partition"
    exit 1
fi
DISKDEVICE="$1"

if [ "x$2" = "x" ]; then
    echo "Specify install disk device, boot partition, and system partition"
    exit 1
fi
BOOTDEVICE="$2"

if [ "x$3" = "x" ]; then
    echo "Specify install disk device, boot partition, and system partition"
    exit 1
fi
SYSTEMDEVICE="$3"

# check if /mntsystem is a directory
if ! [ -d /mntsystem ]; then
    echo "Error, /mntsystem either does not exist or is not a directory"
    exit 1
fi

# check if /mntbootloader is a directory
if ! [ -d /mntbootloader ]; then
    echo "Error, /mntbootloader either does not exist or is not a directory"
    exit 1
fi

# check if SYSTEMDEVICE is mounted or not, must be unmounted
if findmnt "$SYSTEMDEVICE" >/dev/null; then
	echo "Error, $SYSTEMDEVICE is already mounted"
	exit 1
fi

# check if /mntsystem is mounted or not, must be unmounted
if findmnt /mntsystem >/dev/null; then
	echo "Error, /mntsystem is already mounted"
	exit 1
fi

# Let the user format the partition
#mkfs "$ROOTDEVICE"

UUID=$(blkid -s UUID -o value "$SYSTEMDEVICE")
if [ "x$UUID" = "x" ]; then
    echo "Unable to get UUID for system device $SYSTEMDEVICE (perhaps needs to be formatted)"
    exit 1
fi

if [ "x$BOOTDEVICE" = "x$SYSTEMDEVICE" ]; then
    echo "Error, boot device $BOOTDEVICE and system device $SYSTEMDEVICE are the same"
    exit 1
fi

# check if BOOTDEVICE is mounted or not, must be unmounted
if findmnt "$BOOTDEVICE" >/dev/null; then
	echo "Error, boot device $BOOTDEVICE is already mounted"
	exit 1
fi

# check if /mntbootloader is mounted or not, must be unmounted
if findmnt /mntbootloader >/dev/null; then
	echo "Error, /mntbootloader is already mounted"
	exit 1
fi

# check if partition is vfat
if ! blkid -s TYPE -o value "$BOOTDEVICE" | grep '^vfat$' >/dev/null ; then
    echo "Error, boot partition $BOOTDEVICE is not formatted as vfat"
    exit 1
fi

BOOTUUID=$(blkid -s UUID -o value "$BOOTDEVICE")
if [ "x$BOOTUUID" = "x" ]; then
    echo "Unable to get UUID for boot partition $BOOTDEVICE (perhaps needs to be formatted)"
    exit 1
fi

if ! mount "$BOOTDEVICE" /mntbootloader ; then
    echo "Error, unable to mount boot partition $BOOTDEVICE (perhaps needs to be formatted)"
    exit 1
fi
umount /mntbootloader

SUCCESS=0

if fdisk -l "$DISKDEVICE" | grep '^Disklabel type: dos' >/dev/null ; then
    if ! fdisk -l "$DISKDEVICE" | grep "^$BOOTDEVICE *\*" >/dev/null ; then
        echo "Error, boot partition $BOOTDEVICE is not bootable"
        exit 1
    fi
    if ! PATH="/root:$PATH" dialog --yes-label "Install" --no-label "Cancel" --defaultno --yesno "Install ANaL?\n\nDisk: $DISKDEVICE\nBoot Partition: $BOOTDEVICE\nSystem Partition: $SYSTEMDEVICE" 12 64 ; then
        echo "Installation cancelled"
        exit 1
    fi
    if ! mount "$SYSTEMDEVICE" /mntsystem ; then
        echo "Error, unable to mount system partition $SYSTEMDEVICE (perhaps needs to be formatted)"
        exit 1
    fi
    PATH="/root:$PATH" anal-installer-installSystem.sh | PATH="/root:$PATH" dialog --backtitle "Linux Setup" --programbox 'INSTALLING SYSTEM' 8 80
    RESULT=${PIPESTATUS[0]}
    if [ $RESULT -eq 0 ]; then
        PATH="/root:$PATH" anal-installer-configureSystem.sh
        PATH="/root:$PATH" anal-installer-installMBRBootloaderToDisk:partition:UUID:.sh "$DISKDEVICE" "$BOOTDEVICE" "$UUID"
        SUCCESS=1
    fi
    umount /mntsystem
    sync
elif fdisk -l "$DISKDEVICE" | grep '^Disklabel type: gpt' >/dev/null ; then
    if ! fdisk -l "$DISKDEVICE" | grep "^$BOOTDEVICE" | grep ' EFI System$' >/dev/null ; then
        echo "Error, boot partition $BOOTDEVICE is not EFI System (ef00)"
        exit 1
    fi
    if ! PATH="/root:$PATH" dialog --yes-label "Install" --no-label "Cancel" --defaultno --yesno "Install ANaL?\n\nDisk: $DISKDEVICE\nBoot Partition: $BOOTDEVICE\nSystem Partition: $SYSTEMDEVICE" 12 64 ; then
        echo "Installation cancelled"
        exit 1
    fi
    if ! mount "$SYSTEMDEVICE" /mntsystem ; then
        echo "Error, unable to mount system partition $SYSTEMDEVICE (perhaps needs to be formatted)"
        exit 1
    fi
    PATH="/root:$PATH" anal-installer-installSystem.sh | PATH="/root:$PATH" dialog --backtitle "Linux Setup" --programbox 'INSTALLING SYSTEM' 8 80
    RESULT=${PIPESTATUS[0]}
    if [ $RESULT -eq 0 ]; then
        PATH="/root:$PATH" anal-installer-configureSystem.sh
        PATH="/root:$PATH" anal-installer-installEFIBootloaderToPartition:UUID:.sh "$BOOTDEVICE" "$UUID"
        SUCCESS=1
    fi
    umount /mntsystem
    sync
else
    echo "Error, disk $DISKDEVICE should be either MBR or GPT"
    exit 1
fi

if [ $SUCCESS -eq 1 ]; then
    echo "System installation and configuration is complete."
    echo
    echo "You may now reboot your system."
    exit 0
else
    echo "Installation failed."
    echo
    echo "Better luck next time."
    exit 1
fi

