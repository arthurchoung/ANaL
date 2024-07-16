#!/bin/bash
#
# Adapted from Slackware and Slackware Live installer
#

if [ "x$1" = "x" ]; then
    echo "Specify user name"
    exit 1
fi
UACCOUNT="$1"

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

UPASS1=""
UPASS2=""
UFORM="Define a new password for user '$UACCOUNT'"
TITLE="USER CREATION"
if [ "x$UACCOUNT" = "xroot" ]; then
    TITLE="ROOT USER"
fi

    while [ 0 ]; do
      ${DIALOG} --stdout --ok-label "Submit" --no-cancel \
        --title "$TITLE" \
        --insecure --passwordform "$UFORM" 9 64 0 "Password:" \
        1 1 "$UPASS1" 1 18 40 0 "Repeat password:" 2 1 "$UPASS2" 2 18 40 0 \
      1> $TMP/tempupass

      iii=0
      declare -a USERATTR
      while read LINE ; do
        USERATTR[$iii]="$LINE"
        iii=$(expr $iii + 1)
      done < $TMP/tempupass
      rm -f $TMP/tempupass
      UPASS1="${USERATTR[0]}"
      UPASS2="${USERATTR[1]}"
      unset USERATTR
      if [ -z "$UPASS1" ]; then
        UFORM="Password must not be empty, try again for user '$UACCOUNT'"
      elif [ "$UPASS1" == "$UPASS2" ]; then
        break
      else
        UFORM="Passwords do not match, try again for user '$UACCOUNT'"
      fi
    done
    echo "${UPASS1}"
    unset UPASS1
    unset UPASS2
    unset USERATTR

