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
	"storage_path": "/root/rslsync/.sync",
	"pid_file": "/root/rslsync/.sync/rslsync.pid",
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
		"dir": "/root/rslsync/${key}",
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

sudo mkdir -p /root/rslsync/.sync

sudo mv "${configFile}" /root/rslsync/.sync/sync.conf

sudo systemctl enable resilio-sync
sudo systemctl start resilio-sync


pEnd
