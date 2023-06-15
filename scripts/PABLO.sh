#!/bin/bash
# PABLO.sh
# created: 2022-10-08
############################################################
############################################################

dateStamp=$(date "+%Y%m%d")
timeStamp=$(date "+%H%M")

hostName=$HOSTNAME

scriptNameFull=${0##*/}
scriptName=$(echo "${0##*/}" | cut -d. -f1)
pid=$$

# PABLO Dir todo: move to config file
PABLODir=${HOME}/PABLO
# Shared Directory where files can be transfered to other PABLO enabled systems and where master logs are shared
shareDir="${PABLODir}/share"
# script specific directory
baseDir="${PABLODir}/${scriptName}"
# directory to store logs
logsDir="${baseDir}/logs"
# run flags are used to stop the same script starting twice
runFlagsDir="${baseDir}/flags"
# temp dir will be removed at the end of each run
tmpDir="${baseDir}/tmp"
# input dir for script inputs
inputDir="${baseDir}/input"
# output dir for script outputs and longterm storage
outputDir="${baseDir}/output"

# master log file stores logs for all scripts and are shared across machines
masterLogDir="${shareDir}/MASTER_LOGS"
masterLog="${masterLogDir}/${hostName}_${dateStamp}.log"

# how many days to retain logs (will be removed)
logRetention=30

# how many days to retain output (will be removed)
outputRetention=90

# can this script run more then once
overunProtection=true

# ensures dirs are created
mkdir -p "${logsDir}"
mkdir -p "${runFlagsDir}"
mkdir -p "${tmpDir}"
mkdir -p "${shareDir}"
mkdir -p "${masterLogDir}"
mkdir -p "${inputDir}"
mkdir -p "${outputDir}"

# used at start of script to initiate PABLO script run
pStart () {
	logFile="${logsDir}/${scriptName}_${dateStamp}.log"
	runFlagFile="${runFlagsDir}/${scriptName}.txt"

	startTimeStamp=$(date +%s)

	# regex to check valid script name
	checkRegex="^[0-9a-zA-Z_-]*\.sh$"

	echo "${scriptNameFull}"

	# if script name is invalid fail
	if [[ ! ${scriptNameFull} =~ ${checkRegex} ]]; then
		pError "START failed: name invalid \"${scriptNameFull}\""
	fi
	
	if test -e "${runFlagFile}" && ${overunProtection} ; then
		pidFile=$(cat "${runFlagFile}")
		pMasterLog "Error START failed: already running with PID \"${pidFile}\""
		exit 99
	fi

	# delete retained logs
	find "${logsDir}" -type f -mtime +${logRetention} -exec rm -f {} \;

	# delete retained outputs
	find "${outputDir}" -type f -mtime +${outputRetention} -exec rm -f {} \;

	touch "${runFlagFile}"
	echo $$ > "${runFlagFile}"


	pMasterLog "STARTED: with PID \"${pid}\""

}

# create log on script log only
pLog () {
	dateTime=$(date "+%Y-%m-%d %H:%M:%S")

	echo "${dateTime} [${pid}:${scriptName}] ${1}" >> "${logFile}"
	echo "${dateTime} ${1}"
}

# will create log on script and master log
pMasterLog () {
	dateTime=$(date "+%Y-%m-%d %H:%M:%S")

	echo "${dateTime} [${pid}:${scriptName}] ${1}" >> "${masterLog}"
	pLog "(M)${1}"
}

# will check if ret value is error
# $1=retValue	$2=component that failed
pCheckError () {
	if [ "$1" != 0 ]; then
		pError "$2 failed with return $1"
	fi
}

# will create error log on script and master log
pError () {
	pMasterLog "ERROR ${1}"

	pEnd 1
}

pEnd () {
        returnCode=${1:-0}
	# Remove temp files
	rm -f "${tmpDir}/*"
	rmRet=$?
	if [ $rmRet != 0 ]; then
		pMasterLog "END FAILED: removing tmp files, rm returned $rmRet"
	fi

	# Remove run flag
	rm -f "${runFlagFile}"
	rmRet=$?
	if [ $rmRet != 0 ]; then
		pMasterLog "END FAILED: removing running flag, rm returned $rmRet"
	fi
	
	finishTimeStamp=$(date +%s)
	totalExecTime=$(($finishTimeStamp - $startTimeStamp))
	
	pMasterLog "ENDED execution in ${totalExecTime} secs"

	exit "$returnCode"
}
