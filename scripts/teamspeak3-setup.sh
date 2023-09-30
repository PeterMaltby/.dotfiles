#!/bin/bash
# teamspeak3-setup.sh
# author: peterm
# created: 2023-09-29
#############################################################
source "$S/PABLO.sh"

downloadUrl="https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_amd64-3.13.7.tar.bz2"
downloadedTar="${tmpDir}/teamspeak3.tar.bz2"
downloadedFiles="${tmpDir}/teamspeakExtract"

teamspeakHomeDir="/opt/teamspeak"

tmpServiceFile="${tmpDir}/teamspeak.service"
systemServiceFile="/lib/systemd/system/teamspeak.service"
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
mkdir "${downloadedFiles}/"
tar -xvf "${downloadedTar}" -C "${downloadedFiles}"
pCheckError $? "tar"

pLog "moving files to ${teamspeakHomeDir}"
sudo mv ${downloadedFiles}/* ${teamspeakHomeDir}
pCheckError $? "mv"

pLog "agreeing to licence"
sudo touch "${teamspeakHomeDir}/.ts3server_license_accepted"

pLog "changing owner of ${teamspeakHomeDir} to teamspeak user"
sudo chown -R teamspeak: ${teamspeakHomeDir}
pCheckError $? "chown"

pLog "creating service file"
cat > "${tmpServiceFile}" << EOF
[Unit]
Description=Team Speak 3 Server
After=network.target
[Service]
WorkingDirectory=${teamspeakHomeDir}
User=teamspeak
Group=teamspeak
Type=forking
ExecStart=${teamspeakHomeDir}/ts3server_startscript.sh start inifile=ts3server.ini
ExecStop=${teamspeakHomeDir}/ts3server_startscript.sh stop
PIDFile=${teamspeakHomeDir}/ts3server.pid
RestartSec=15
Restart=always
[Install]
WantedBy=multi-user.target
EOF
pCheckError $? "cat"

pLog "moving service file to ${systemServiceFile}"
sudo mv "${tmpServiceFile}" ${systemServiceFile}
pCheckError $? "mv"

pLog "changing ${systemServiceFile} to root owner"
sudo chown root:root ${systemServiceFile}
pCheckError $? "chown"
sudo restorecon ${systemServiceFile}
pCheckError $? "restorecon"

pLog "service created successfully! please enable and start the systemctl service"
pLog "\"systemctl --system daemon-reload\""
pLog "\"systemctl enable teamspeak\""


pEnd
