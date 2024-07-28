#!/bin/bash

set -x

gcc -o anal-alsa-generatePanel anal-alsa-generatePanel.c -lasound
gcc -o anal-alsa-printFirstElement anal-alsa-printFirstElement.c -lasound
gcc -o anal-alsa-printUpdates anal-alsa-printUpdates.c -lasound
gcc -o anal-alsa-printStatus anal-alsa-printStatus.c -lasound
gcc -o anal-alsa-setMute: anal-alsa-setMute:.c -lasound
gcc -o anal-alsa-setVolume anal-alsa-setVolume.c -lasound
gcc -o anal-alsa-setValues anal-alsa-setValues.c -lasound
gcc -o anal-monitorBlockDevices anal-monitorBlockDevices.c
gcc -o anal-monitorNetworkInterfaces anal-monitorNetworkInterfaces.c
gcc -o anal-monitorMonitors anal-monitorMonitors.c
gcc -o anal-monitorMountChanges anal-monitorMountChanges.c
gcc -o anal-packRectanglesIntoWidth:height:... anal-packRectanglesIntoWidth:height:....c

