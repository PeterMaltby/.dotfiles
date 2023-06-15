#!/bin/bash
# resilio.sh
# author: peterm
# created: 2023-06-15
#############################################################
source "$S/PABLO.sh"

configFile="${inputDir}/sync.conf"
configTemplateFile="$S/.share/resilio.template"

serviceFile="${outputDir}/resilio-sync.service"

syncStorage="/resilioSync"

#############################################################
pStart

if [ ! -f "${configFile}" ]; then
    pLog "config file ($configFile) not created creating template"
    cp "$configTemplateFile" "$configFile"
    sed -i "s/DEVICE_NAME/${hostName}/g" "$configFile"
    sed -i "s/STORAGE_PATH/${syncStorage}/g" "$configFile"
    pLog "template config file created at $configFile please populate then rerun"
    pEnd
fi

pLog "config file located at $configFile is being installed"

mkdir -p "$syncStorage"
cp "$configFile" "$syncStorage/sync.conf"
pCheckError $? "cp config file to $syncStorage"

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
pCheckError $? "chown of service file"
sudo chmod 644 /usr/lib/systemd/system/resilio-sync.service
pCheckError $? "chmod of service file"

pLog "service created sucessfully! please enable and start the systemctl service"

pEnd
