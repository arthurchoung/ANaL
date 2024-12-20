#!/bin/bash
#
# Adapted from Slackware and Slackware Live installer

T_PX="/mntsystem"
if ! findmnt "${T_PX}" >/dev/null; then
    echo "Error, ${T_PX} is not mounted with system"
    exit 1
fi

# The script defaults to curses dialog but Xdialog is a good alternative:
DIALOG=${DIALOG:-"dialog"}

#!/bin/sh
# Liveslak replacement for Slackware's SeTpassword script.

TMP="${T_PX}/var/log/setup/tmp"
if [ ! -d $TMP ]; then
  mkdir -p $TMP
fi

# Set the root password:
UPASS=$( anal-installer-changePasswordForUser:.sh root )
echo "root:${UPASS}" | chroot ${T_PX} /usr/sbin/chpasswd
unset UPASS

# Set up a user account,
# This will set UFULLNAME, UACCOUNT and USHELL variables:
if anal-installer-addUser.sh 2>&1 1> $TMP/temppasswd ; then
  # User filled out the form, so let's get the results for
  # UFULLNAME, UACCOUNT, UACCTNR and USHELL:
  source $TMP/temppasswd
  rm -f $TMP/temppasswd
  # Set a password for the new account:
  UPASS=$( anal-installer-changePasswordForUser:.sh $UACCOUNT )
  # Create the account and set the password:
  chroot ${T_PX} /usr/sbin/useradd -c "$UFULLNAME" -g users -G wheel,audio,cdrom,floppy,plugdev,video,power,netdev,lp,scanner,dialout,games,disk,input -u ${UACCTNR} -d /home/${UACCOUNT} -m -s ${USHELL} ${UACCOUNT}
  echo "${UACCOUNT}:${UPASS}" | chroot ${T_PX} /usr/sbin/chpasswd
  unset UPASS

  # Configure sudoers:
#  chmod 640 ${T_PX}/etc/sudoers
#  sed -i ${T_PX}/etc/sudoers -e 's/# *\(%wheel\sALL=(ALL)\sALL\)/\1/'
#  chmod 440 ${T_PX}/etc/sudoers
fi # End user creation

