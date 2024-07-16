#!/bin/bash

FONT=""
if [ $ANAL_SCALING -gt 1 ]; then
    FONT="-fn 12x24"
fi

xterm $FONT -geometry 80x50 -bg black -fg white -cr '#ff8800' +bc +uc

