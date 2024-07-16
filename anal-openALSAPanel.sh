#!/bin/bash

if [ "x$1" = "x" ]; then
    echo "specify alsa device, example 'hw:0'"
    exit 1
fi

anal-generateALSAPanel "$@" | anal show ALSAPanel | anal-setALSAValues "$1"

