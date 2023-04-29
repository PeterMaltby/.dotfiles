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

serviceFile="${tmpDir}/resilio-sync.service"

user="peterm"
syncStorage="/home/${user}/resilioSync"

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
	"storage_path": "${syncStorage}/.sync",
	"pid_file": "${syncStorage}/.sync/rslsync.pid",
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
mkdir -p "${syncStorage}/.sync"
sudo chmod g+rw "${syncStorage}"
pCheckError $? "chmod ${syncStorage}"
cp "${configFile}" "${syncStorage}/sync.conf"

pLog "generating service file"
cat > "${serviceFile}" << EOF
[Unit]
Description=Resilio Sync service
Documentation=https://help.resilio.com
After=network.target

[Service]
Type=forking
UMask=0002
Restart=on-failure
PermissionsStartOnly=true

User=rslsync
Group=rslsync
Environment="SYNC_USER=rslsync"
Environment="SYNC_GROUP=rslsync"

Environment="SYNC_RUN_DIR=/var/run/resilio-sync"
Environment="SYNC_LIB_DIR=/var/lib/resilio-sync"
Environment="SYNC_CONF_DIR=${syncStorage}"

PIDFile=/var/run/resilio-sync/sync.pid

ExecStartPre=/bin/mkdir -p \${SYNC_RUN_DIR} \${SYNC_LIB_DIR}
ExecStartPre=/bin/chown -R \${SYNC_USER}:\${SYNC_GROUP} \${SYNC_RUN_DIR} \${SYNC_LIB_DIR}
ExecStart=/usr/bin/rslsync --config ${syncStorage}/sync.conf
ExecStartPost=/bin/sleep 1

[Install]
WantedBy=multi-user.target
EOF

sudo cp "${serviceFile}" /usr/lib/systemd/system/resilio-sync.service
pCheckError $? "cp service file to systemd"
sudo chown root:root /usr/lib/systemd/system/resilio-sync.service
sudo chmod 644 /usr/lib/systemd/system/resilio-sync.service

pLog "enableing sevice and starting with config file"
sudo systemctl enable resilio-sync
pCheckError $? "systemctl enable"
sudo systemctl start resilio-sync
pCheckError $? "systemctl start"

pEnd