#!/bin/bash

if [ "$#" -lt 4 ]; then
    echo "specify from, to, subject, body, attachment"
    exit 1
fi

RESULT=$( anal-generateEmailFrom:to:subject:body:attachment:.py "$@" )

if [ "x$RESULT" == "x" ]; then
    anal alert "unable to generate email"
    exit 1
fi

( cat <<EOF
$RESULT
EOF
) | msmtp --tls-certcheck=off "$2"

EXITCODE=$?
if [ $EXITCODE -ne 0 ]; then
    anal alert "unable to send email"
    exit 1
fi

anal alert "email probably sent, but you never know with email"

