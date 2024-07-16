#!/bin/bash
#
# Adapted from Slackware and Slackware Live installer
#

T_PX="/mntsystem"
if ! findmnt "${T_PX}" >/dev/null; then
    echo "Error, ${T_PX} is not mounted with system"
    exit 1
fi

# The script defaults to curses dialog but Xdialog is a good alternative:
DIALOG=${DIALOG:-"dialog"}

TMP="${T_PX}/var/log/setup/tmp"
if [ ! -d $TMP ]; then
  mkdir -p $TMP
fi

freeuid() {
  # Get the first free UIDNumber after 999:
  local LUIDS=$( cat ${T_PX}/etc/passwd | cut -d: -f3 | sort -n )
  local LUID=999
  while true; do
    LUID=$(( $LUID + 1))
    if ! echo $LUIDS | grep -F -q -w "$LUID"; then
      break;
    fi
  done
  echo $LUID
}
FREEUID="$(freeuid)"

UFULLNAME=""
UACCOUNT=""
UACCTNR="$FREEUID"
USHELL="/bin/bash"
UFORM="Fill out your user details:"
while [ 0 ]; do
  ${DIALOG} --stdout --ok-label "Submit" --no-cancel \
    --title "USER CREATION" \
    --form "$UFORM" \
    11 64 0 \
      "Full Name:"   1 1 "$UFULLNAME" 1 14 40 0 \
      "Logonname:"   2 1 "$UACCOUNT"  2 14 32 0 \
      "UIDNumber:"   3 1 "$UACCTNR"   3 14 12 0 \
      "Login Shell:" 4 1 "$USHELL"    4 14 12 0 \
    1> $TMP/tempuacct
  iii=0
  declare -a USERATTR
  while read LINE ; do
    USERATTR[$iii]="$LINE"
    iii=$(expr $iii + 1)
  done < $TMP/tempuacct
  rm -f $TMP/tempuacct
  UFULLNAME="${USERATTR[0]}"
  UACCOUNT="${USERATTR[1]}"
  UACCTNR="${USERATTR[2]}"
  USHELL="${USERATTR[3]}"
  unset USERATTR
  UINPUT=0
  # Validate the input:
  UACC_INVALID1="$(echo ${UACCOUNT:0:1} |tr -d 'a-z_')"
  UACC_INVALID="$(echo ${UACCOUNT:1} |tr -d 'a-z0-9_-')"
  if [ -n "$UACC_INVALID1" -o -n "$UACC_INVALID" ]; then
    # User account contains invalid characters, let's remove them all:
    UINPUT=1
    UACCOUNT="$(echo ${UACCOUNT} |tr -cd 'a-z_')"
  fi
  if [ -z "$UACCOUNT" -o -z "$UFULLNAME" ]; then
    # User account or fullname is empty, let's try again:
    UINPUT=$(expr $UINPUT + 2)
  fi
  if chroot ${T_PX} /usr/bin/id -u ${UACCTNR} 1>/dev/null 2>/dev/null ; then
    # UidNumber is already in use, fall back to sane default:
    UINPUT=$(expr $UINPUT + 4)
    UACCTNR=$FREEUID
  fi
  if ! grep -q ${USHELL} ${T_PX}/etc/shells ; then
    # Login shell is invalid, suggest the bash shell again:
    UINPUT=$(expr $UINPUT + 8)
    USHELL=/bin/bash
  fi
  if [ $UINPUT -eq 0 ]; then
    break
  elif [ $UINPUT -eq 1 ]; then
    UFORM="Please only use valid characters for logonname"
  elif [ $UINPUT -eq 2 ]; then
    UFORM="Please enter your logon and full name"
  elif [ $UINPUT -eq 3 ]; then
    UFORM="Use valid characters for logonname, and enter full name"
  elif [ $UINPUT -eq 4 ]; then
    UFORM="Enter unused number for your account, $FREEUID is a good default"
  elif [ $UINPUT -eq 8 ]; then
    UFORM="Please enter a valid shell"
  else
    UFORM="Fill all fields, using valid logonname/uidnumber values"
  fi
done

echo "UACCOUNT=$UACCOUNT"
echo "UFULLNAME='$UFULLNAME'"
echo "UACCTNR=$UACCTNR"
echo "USHELL=$USHELL"
