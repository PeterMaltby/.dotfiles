#!/bin/bash
# internetMonitor.sh
# author: peterm
# created: 2024-08-26
#############################################################
source "$S/PABLO.sh"

outputFile="${outputDir}/log.csv"
shareFile="/home/peterm/peter-wiki/internet.log"
#############################################################
pStart

if [ ! -f "${outputFile}" ]; then
	pLog "creating and adding headers to ${outputFile}"
        speedtest --csv-header > $outputFile
fi

pLog "running speedtest"
speedtest --csv >> $outputFile
pCheckError $? "running speedtest"

cp $outputFile $shareFile
pCheckError $? "moving file to share"


pEnd

