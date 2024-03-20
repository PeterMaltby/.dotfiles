#!/bin/bash
# resilio.sh
# author: peterm
# created: 2024-03-20
#############################################################
source "$S/PABLO.sh"

sourceListEntry="deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free"
sourcePubKeyUrl="https://linux-packages.resilio.com/resilio-sync/key.asc"
tmpKeyFile="${tmpDir}/key.asc"

configFile="${tmpDir}/config.json"


syncStorage="${HOME}/rslsync"
#############################################################
pStart

pLog "adding resilio source to sources list"
echo $sourceListEntry | sudo tee -a /etc/apt/sources.list
pCheckError $? "adding source to source entry list"

pLog "getting and adding gpg key from $sourcePubKeyUrl"
wget -qO- $sourcePubKeyUrl | sudo tee /etc/apt/trusted.gpg.d/resilio.asc
pCheckError $? "curl pub key"

pLog "installing resilio"
sudo apt update
sudo apt install resilio-sync

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
cat ${configFile}

mv ${configFile} 

pLog "service created sucessfully! please enable and start the systemctl service"

pEnd
