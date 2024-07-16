#!/bin/bash

set -x

gcc -o anal-generateALSAPanel anal-generateALSAPanel.c -lasound
gcc -o anal-printALSAUpdates anal-printALSAUpdates.c -lasound
gcc -o anal-printALSAStatus anal-printALSAStatus.c -lasound
gcc -o anal-setALSAMute: anal-setALSAMute:.c -lasound
gcc -o anal-setALSAVolume anal-setALSAVolume.c -lasound
gcc -o anal-setALSAValues anal-setALSAValues.c -lasound
gcc -o anal-monitorBlockDevices anal-monitorBlockDevices.c
gcc -o anal-monitorNetworkInterfaces anal-monitorNetworkInterfaces.c
gcc -o anal-monitorMonitors anal-monitorMonitors.c
gcc -o anal-monitorMountChanges anal-monitorMountChanges.c
gcc -o anal-packRectanglesIntoWidth:height:... anal-packRectanglesIntoWidth:height:....c

