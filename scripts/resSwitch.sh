#!/bin/bash
# resSwitch.sh
# author: peterm
# created: 2023-10-02
#############################################################
source "$S/PABLO.sh"

quiteMode=true

monitorName="HDMI-A-0"
#############################################################
pStart

xrandrOutput=$(xrandr | grep $monitorName)
resolution=$(echo "$xrandrOutput" | awk '{print $4}')

if [ "${resolution}" == "3840x2160+1080+0" ]; then
    pLog "setting display to 1080p"
    echo "setting display to 1080p"
    xrandr --output HDMI-A-0 --mode 1920x1080
fi

if [ "${resolution}" == "1920x1080+1080+0" ]; then
    echo "setting display to 4k"
    pLog "setting display to 4k"
    xrandr --output HDMI-A-0 --mode 3840x2160
fi

if [ "${resolution}" != "3840x2160+1080+0" ] && \
   [ "${resolution}" != "1920x1080+1080+0" ]; then
    pError "resolution was: \"${resolution}\"!" 
fi

pEnd
