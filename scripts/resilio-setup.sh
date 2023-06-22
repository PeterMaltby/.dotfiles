#!/bin/bash
# resillio-setup.sh
# author: peterm
# created: 2023-04-28
#############################################################
# shellcheck source=/home/peterm/scripts/PABLO.sh
source "$S/PABLO.sh"

downloadUrl="https://download-cdn.resilio.com/2.7.3.1381/RPM/resilio-sync-2.7.3.1381-1.x86_64.rpm"
downloadedFile="${tmpDir}/res-sync.rpm"

configFile="${tmpDir}/sync.conf"
keysFile="${inputDir}/keys.txt"
keyCheckRegex="^F[0-9A-Z]{32,32}$"

user="peterm"
# set this file!
# syncStorage="/resilioSync"
syncConfigFile="/etc/resilio-sync/config.json"

#############################################################
pStart

if [ ! -f "${keysFile}" ]; then
	pLog "populate ${keysFile} with keys for folders you wish to sync, then rerun"
	pEnd
fi

pLog "constructing config File"
touch "${configFile}"

cat > "${configFile}" << EOF
{
	"device_name": "${hostName}",
	"listening_port": 8888,
        "pid_file": "/run/resilio-sync/sync.pid",
	"storage_path": "${syncStorage}/.sync",
	"use_upnp": false,

	"shared_folders" :
	[
EOF

# to deal with json last line of list stuff
first=true

while read -r key; do
	if [[ ! "${key}" =~ ${keyCheckRegex} ]]; then
		pError "invalid key: \"${key}\" in file ${keysFile}"
	fi

	if [ ${first} == true ]; then
		first=false
	else
		echo "	}," >> "${configFile}"
	fi

	cat >> "${configFile}" << EOF
	{
		"secret": "${key}",
		"dir": "${syncStorage}/${key}",
		"use_relay_server" : true,
		"use_tracker": false,
		"search_lan": false,
		"use_sync_trash" : false,
		"overwrite_changes": false,
		"selective_sync": false
EOF

done < "${keysFile}"

cat >> "${configFile}" << EOF
	}
	]
}
EOF

pLog "Config file created succesfully at: ${configFile}"

pLog "downloading binaries ${downloadUrl}"
curl ${downloadUrl} --output "${downloadedFile}"
pCheckError $? "curl"

pLog "installing binaries with rpm"
sudo rpm -i "${downloadedFile}"
pCheckError $? "rpm install"

pLog "adding users to groups"
sudo usermod -aG "${user}" rslsync
pCheckError $? "usermod rslsync and ${user}"
sudo usermod -aG rslsync "${user}"
pCheckError $? "usermod rslsync and ${user}"

pLog "creating rslsync folder and adding config file"
sudo mkdir -p "${syncStorage}/.sync"
sudo chmod g+rw "${syncStorage}"
pCheckError $? "chmod ${syncStorage}"
sudo cp "${configFile}" "${syncConfigFile}"
pCheckError $? "cp config file to ${syncConfigFile}"

sudo chown -R rslsync:rslsync "${syncStorage}"
pCheckError $? "chown ${syncStorage}"

sudo chown -R rslsync:rslsync "${syncConfigFile}"
pCheckError $? "chown ${syncConfigFile}"

pLog "service created sucessfully! please enable and start the systemctl service"

pEnd
