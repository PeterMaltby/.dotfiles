#!/bin/bash
# teamspeak.sh
# author: peterm
# created: 2024-03-20
#############################################################
source "$S/PABLO.sh"

baseDir="/home/teamspeak"

teamspeakDownload="https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_amd64-3.13.7.tar.bz2"

teamspeakLocation="${baseDir}/teamspeak3.tar.bz2"
teamspeakRunDir="${baseDir}/teamspeak3-server_linux_amd64"

serviceFileTemplate="$S/.share/teamspeak.service"
serviceFileTmp="${tmpDir}/teamspeak.service"
serviceFile="/etc/systemd/system/teamspeak.service"

#############################################################
pStart

#sudo apt update
#sudo apt install lbzip2
#
#sudo groupadd -r teamspeak
#sudo useradd -m -r -g teamspeak -s /bin/bash teamspeak
#
#sudo -u teamspeak mkdir ${baseDir}/server ${baseDir}/tools
#
#curl $teamspeakDownload --output $teamspeakLocation
#
#sudo -u teamspeak touch "${teamspeakRunDir}/.ts3server_license_accepted"

cp -p $serviceFileTemplate $serviceFileTmp
sed -i "s'BASE_DIR'${teamspeakRunDir}'g" $serviceFileTmp
sudo mv $serviceFileTmp $serviceFile
sudo chown root:root $serviceFile

pEnd
