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

#############################################################
pStart

function rcon {
	$mcrcon -H localhost -p $rconPort -p $rconPass "$1"
}

rcon "say hello there!"

pEnd
