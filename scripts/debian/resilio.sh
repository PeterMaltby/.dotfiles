#!/bin/bash
# resilio.sh
# author: peterm
# created: 2024-03-20
#############################################################
source "$S/PABLO.sh"

sourceListEntry="deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free"
sourcePubKeyUrl="https://linux-packages.resilio.com/resilio-sync/key.asc"
tmpKeyFile="${tmpDir}/key.asc"

configFile="${inputDir}/sync.conf"
configTemplateFile="$S/.share/resilio.template"

serviceFile="${outputDir}/resilio-sync.service"

syncStorage="${HOME}/.config/rslsync"
#############################################################
pStart

pLog "adding resilio source to sources list"
echo $sourceListEntry | sudo tee -a /etc/apt/sources.list
pCheckError $? "adding source to source entry list"

pLog "getting and adding source key"
curl $sourcePubKeyUrl > "$tmpKeyFile"
pCheckError $? "curl pub key"

pLog "adding key to apt"
sudo apt-key add $tmpKeyFile

pEnd

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
