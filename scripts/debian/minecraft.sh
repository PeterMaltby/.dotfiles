#!/bin/bash
# resilio.sh
# author: peterm
# created: 2024-03-20
#############################################################
source "$S/PABLO.sh"

baseDir="/home/minecraft"
rconPort=25575
rconPass="test"

serverJarDownload="https://launcher.mojang.com/v1/objects/b58b2ceb36e01bcd8dbf49c8fb66c55a9f0676cd/server.jar"

serverJarLocation="${baseDir}/server/server.jar"

serviceFileTemplate="$S/.share/minecraft.service"
serviceFileTmp="${tmpDir}/minecraft.service"
serviceFile="/etc/systemd/system/minecraft.service"

serverPropsTemplate="$S/.share/server.properties"
serverPropsTmp="${tmpDir}/server.properties"
serverProps="${baseDir}/server/server.properties"

#############################################################
pStart

sudo apt update
sudo apt install default-jre gcc -y
java --version

sudo groupadd -r minecraft
sudo useradd -m -r -g minecraft -s "/bin/bash" minecraft

sudo -u minecraft mkdir ${baseDir}/server ${baseDir}/tools

sudo -u minecraft curl $serverJarDownload --output $serverJarLocation
sudo -u minecraft chmod +x $serverJarLocation

sudo -u minecraft java -jar $serverJarLocation nogui

sudo cd ${baseDir}/tools
sudo -u minecraft pwd
sudo -u minecraft git clone  git://git.code.sf.net/p/mcrcon/code mcrcon-code
sudo cd mcrcon-code
sudo -u minecraft gcc mcrcon.c -o mcrcon
sudo -u minecraft cp mcrcon ${baseDir}/

cp -p $serviceFileTemplate $serviceFileTmp
sed -i "s'BASE_DIR'${baseDir}'g" $serviceFileTmp
sed -i "s/RCON_PORT/${rconPort}/g" $serviceFileTmp
sed -i "s/RCON_PASS/${rconPass}/g" $serviceFileTmp
sudo mv $serviceFileTmp $serviceFile
sudo chown root:root $serviceFile

cp -p $serverPropsTemplate $serverPropsTmp
sed -i "s/RCON_PORT/${rconPort}/g" $serverPropsTmp
sed -i "s/RCON_PASS/${rconPass}/g" $serverPropsTmp
sudo mv $serverPropsTmp $serverProps
sudo chown minecraft:minecraft $serverProps

sudo -u minecraft sed -i "s/eula=false/eula=true/g" $baseDir/server/eula.txt

pEnd
