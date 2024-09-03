#!/bin/bash
# dwmStatusBar.sh
# author: peterm
# created: 2023-05-12
#############################################################
source "$S/PABLO.sh"


wallpaperDir="$HOME/wallpaper"

lastDisplayed="$outputDir/lastImage.txt"
#############################################################
pStart

whoami

if [ -f "$lastDisplayed" ]; then
    lastImageName=$(cat "${lastDisplayed}")
    pLog "Last image used was ${lastImageName}"
else
    pMasterLog "no file found at $lastDisplayed: will create"
    touch "$lastDisplayed"
    pCheckError $? "touch $lastDisplayed"
fi

# use Next flag true when lastDisplayed found set true to select first image
useNext=true
for entry in "$wallpaperDir"/*
do
    if [ $useNext == "true" ]; then
        newWallpaper=$entry
        useNext=false
    fi
    if [ "$entry" == "$lastImageName" ]; then
        useNext=true
    fi

done

pMasterLog "new wallpaper will be: $newWallpaper"
feh --bg-scale "$newWallpaper"
pCheckError $? "feh"

echo "$newWallpaper" > "$lastDisplayed"

pEnd
