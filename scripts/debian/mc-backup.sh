#!/bin/bash
# mc-player-log.sh
# author: peterm
# created: 2024-03-22
#############################################################
source "$S/PABLO.sh"

baseDir="/home/minecraft"
mcrcon="${baseDir}/mcrcon"
rconPort=25575
rconPass="test"

backupLocation="${shareDir}/mc-backups"
#############################################################
pStart

function rcon {
	$mcrcon -H localhost -p $rconPort -p $rconPass "$1"
}

rcon "say [§4WARNING§r] taking backup in 1 minute"
sleep 1m
rcon "say [§4WARNING§r] starting backup"

rcon "save-off"
rcon "save-all flush"

sleep 10

mkdir -p "${backupLocation}"

tar -cvpzf "${backupLocation}/server-$(date +%Y%m%d_%H%M).tar.gz" $baseDir/server
pCheckError $? "tar"
rcon "save-on"

find ${backupLocation} -type f -mtime +1 -name "server-*.tar.gz" -delete

rcon "say [§bNOTICE§r] backup complete have a nice day"

pEnd
