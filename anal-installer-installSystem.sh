#!/bin/bash
#
# Adapted from Slackware and Slackware Live installer
#

ROOTDIR="/mntsystem"
if ! [ -d "$ROOTDIR" ]; then
    echo "Error, $ROOTDIR either does not exist or is not a directory"
    exit 1
fi

ROOTDEVICE=$( findmnt -P -M $ROOTDIR | sed 's/.*SOURCE="\([^"]*\)".*/\1/' )
if [ "x$ROOTDEVICE" = "x" ]; then
    echo "Error, $ROOTDIR is not mounted with system"
    exit 1
fi

UUID=$( blkid -s UUID -o value $ROOTDEVICE )
if [ "x$UUID" = "x" ]; then
    echo "Error, unable to get UUID"
    exit 1
fi

#
# Install Packages in /mntinstaller/InstallerPackages*
#

COUNT=$( find /mntinstaller/InstallerPackages*/*.t?z | wc -l )
INDEX=1

for package in /mntinstaller/InstallerPackages*/*.t?z ; do
    echo "[$INDEX/$COUNT]"
    echo
    if ! installpkg -root $ROOTDIR -terse -priority ADD $package ; then
        echo "Unable to install $package, aborting installation..."
        exit 1
    fi
    echo -e -n "\r"
    ((INDEX++))
done

$ROOTDIR/sbin/ldconfig -r $ROOTDIR

#
# Generate /etc/fstab
#

echo "Generating /etc/fstab..."
echo -e -n "\r"

cat /dev/null > $ROOTDIR/etc/fstab
printf "%s %-16s %-11s %-16s %-3s %s\n" "UUID=\"$UUID\"" "/" "ext4" "defaults" "1" "1" >> $ROOTDIR/etc/fstab
printf "%-16s %-16s %-11s %-16s %-3s %s\n" "#/dev/cdrom" "/mnt/cdrom" "auto" "noauto,owner,ro,comment=x-gvfs-show" "0" "0" >> $ROOTDIR/etc/fstab
printf "%-16s %-16s %-11s %-16s %-3s %s\n" "/dev/fd0" "/mnt/floppy" "auto" "noauto,owner" "0" "0" >> $ROOTDIR/etc/fstab
printf "%-16s %-16s %-11s %-16s %-3s %s\n" "devpts" "/dev/pts" "devpts" "gid=5,mode=620" "0" "0" >> $ROOTDIR/etc/fstab
printf "%-16s %-16s %-11s %-16s %-3s %s\n" "proc" "/proc" "proc" "defaults" "0" "0" >> $ROOTDIR/etc/fstab
printf "%-16s %-16s %-11s %-16s %-3s %s\n" "tmpfs" "/dev/shm" "tmpfs" "nosuid,nodev,noexec" "0" "0" >> $ROOTDIR/etc/fstab

#
# Copy /mntinstaller/InstallerCustom*
#

for custom in /mntinstaller/InstallerCustom* ; do
    echo "Copying $custom..."
    echo -e -n "\r"
    cp -R -P -T $custom $ROOTDIR
done

#
# Done
#

echo "$COUNT packages installed."
echo -e -n "\r"

exit 0

