#!/bin/bash

if ! PATH="/root:$PATH" dialog \
  --yes-label "Continue" \
  --no-label "Stop" \
  --defaultno --yesno \
"\
\n\
Before installing, you must first partition the disk either as MBR or GPT.\n\
\n\
For an MBR disk, the first partition must be vfat (type 'c') and will be used for the bootloader. 100 MB is sufficient. It must be marked as bootable.\n\
\n\
For a GPT disk, the first partition must be EFI System (type 'ef00') and will be used for the bootloader. 100 MB is sufficient.\n\
\n\
Any other partition may be used as the root partition.\n\
\n\
Both partitions must be formatted before running the installer.\n\
\n\
To erase MBR/GPT data from a disk: sgdisk -Z /dev/sdx\n\
\n\
To partition an MBR disk: fdisk /dev/sdx\n\
\n\
To partition a GPT disk: gdisk /dev/sdx\n\
\n\
To format a partition as vfat: mkfs.vfat /dev/sdx1\n\
\n\
To format a partition as ext4: mkfs.ext4 /dev/sdx2\n\
\n\
To set up the installation of ANaL, click Continue.\
"\
  16 64 ; then
    exit 1
fi

if ! [ -d /mntinstaller ]; then
    # Directory /mntinstaller does not exit
    PATH="/root:$PATH" dialog --msgbox "Error, /mntinstaller either does not exist or is not a directory" 16 68
    exit 1
fi

DIDMOUNTINSTALLER=0

if ! findmnt -P -M /mntinstaller ; then
    DEVICE=$( findfs LABEL=ANALINSTALLER )
    if [ $? -ne 0 ]; then
        # Unable to find ANALINSTALLER
        PATH="/root:$PATH" dialog --msgbox "Error, unable to find installer device" 16 68
        exit 1
    fi
    if ! mount -o ro "$DEVICE" /mntinstaller ; then
        # Unable to mount $DEVICE
        PATH="/root:$PATH" dialog --msgbox "Error, unable to mount device $DEVICE" 16 68
        exit 1
    fi
    DIDMOUNTINSTALLER=1
fi

TEXT=""

RESULTS=( $( PATH="/root:$PATH" anal-installerChooseDisk.pl ) )
if [ ${#RESULTS[@]} -eq 3 ]; then
    TEXT=$( PATH="/root:$PATH" anal-installerInstallToDisk:bootPartition:systemPartition:.sh ${RESULTS[0]} ${RESULTS[1]} ${RESULTS[2]} )
else
    TEXT="Installation aborted."
fi

if [ $DIDMOUNTINSTALLER -eq 1 ]; then
    umount /mntinstaller
fi

PATH="/root:$PATH" dialog --msgbox "$TEXT" 16 68

