#!/bin/bash
# resilio.sh
# author: peterm
# created: 2023-06-15
#############################################################
source "$S/PABLO.sh"

configFile="${inputDir}/sync.conf"
configTemplateFile="$S/.share/resilio.template"

serviceFile="${outputDir}/resilio-sync.service"

syncStorage="${HOME}/.config/rslsync"
#############################################################
pStart

if [ ! -f "${configFile}" ]; then
    pLog "config file ($configFile) not created creating template"
    cp "$configTemplateFile" "$configFile"
    sed -i "s/DEVICE_NAME/${USER}@${hostName}/g" "$configFile"
    sed -i "s/STORAGE_PATH/${syncStorage}/g" "$configFile"
    pLog "template config file created at $configFile please populate then rerun"
    pEnd
fi

pLog "config file located at $configFile is being installed"

mkdir -p "$syncStorage"
cp "$configFile" "$syncStorage/rslsync.conf"
pCheckError $? "cp config file to $syncStorage"

pLog "service created sucessfully! please enable and start the systemctl service"

pEnd
