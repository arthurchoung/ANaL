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

#
# Set root password and create new user
#

anal-installer-setupAccounts.sh

#
# Run package setup scripts
#

# Disable making USB boot drive
chmod 644 $ROOTDIR/var/log/setup/setup.80.make-bootdisk

# Disable running of xwmconfig
chmod 644 $ROOTDIR/var/log/setup/setup.xwmconfig

# Make bind mounts for /dev, /proc, and /sys:
mount -o bind /dev $ROOTDIR/dev 2> /dev/null
mount -o bind /proc $ROOTDIR/proc 2> /dev/null
mount -o bind /sys $ROOTDIR/sys 2> /dev/null

# Post installation and setup scripts added by packages.
if [ -d $ROOTDIR/var/log/setup ]; then
  for INSTALL_SCRIPTS in $ROOTDIR/var/log/setup/setup.* ; do
    SCRIPT=`basename $INSTALL_SCRIPTS`
    # Here, we call each script in /var/log/setup. Two arguments are provided:
    # 1 -- the target prefix (normally /, but ${ROOTDIR} from the bootdisk)
    # 2 -- the name of the root device.
    ( cd $ROOTDIR
      if [ -x var/log/setup/$SCRIPT ]; then
        COLOR=on ./var/log/setup/$SCRIPT $ROOTDIR $ROOTDEVICE
      fi
    )
  done
fi

umount $ROOTDIR/dev
umount $ROOTDIR/proc
umount $ROOTDIR/sys

exit 0

