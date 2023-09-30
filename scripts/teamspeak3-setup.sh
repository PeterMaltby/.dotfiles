#!/bin/bash
# teamspeak3-setup.sh
# author: peterm
# created: 2023-09-29
#############################################################
source "$S/PABLO.sh"

downloadUrl="https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_x86-3.13.7.tar.bz2"
downloadedTar="${tmpDir}/teamspeak3.tar.bz2"
downloadedFiles="${tmpDir}/teamspeakExtract"

teamspeakHomeDir="/opt/teamspeak"

#############################################################
pStart

pLog "installing pre reqs"
sudo dnf install -y perl tar net-tools bzip2
pCheckError $? "dnf"


pLog "creating teamspeak user"
sudo useradd teamspeak -d $teamspeakHomeDir
pCheckError $? "useradd"

pLog "downloading binary"
curl ${downloadUrl} --output "${downloadedTar}"
pCheckError $? "curl"

pLog "extracting tar"
tar -xvf "${downloadedTar}" -C "${downloadedFiles}"
pCheckError $? "tar"

pLog "moving files to ${teamspeakHomeDir}"
sudo mv "${downloadedFiles}/*" ${teamspeakHomeDir}
pCheckError $? "mv"

pLog "changing owner of ${teamspeakHomeDir} to teamspeak user"
sudo chown -R teamspeak: ${teamspeakHomeDir}
pCheckError $? "chown"


