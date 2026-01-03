#!/usr/bin/env bash
# PABLO.sh
# created: 2022-10-08
############################################################
if [[ -n "${PABLO_LOADED}" ]]; then
    pError "PABLO ALREADY RUNNING"
    exit 1
fi
readonly PABLO_LOADED=1

scriptNameFull=${0##*/}
scriptName=$(echo "${0##*/}" | cut -d. -f1)
pid=$$

# should be where script file is in my bin
binDir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# For temporary files related to script
tmpDir=/tmp/pablo
# script specific directory
# input dir for script inputs
inputDir="${binDir}/input/${scriptName}"
# output dir for script outputs and longterm storage
# outputDir="${baseDir}/output"
# how many days to retain output (will be removed)
# outputRetention=90

# doesnt work yet but here for when i want to deal with it
quiteMode=false

# ensures dirs are created
mkdir -p "${inputDir}"
# mkdir -p "${outputDir}"
mkdir -p "${tmpDir}"

log_debug() {
    local message=${1}
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # always log
    logger -t "${scriptName}" -p debug "${message}"

    # if quite leave and dont log out to screen
    if [ "$DEBUG" == true ]; then
        # log to screen
        echo -e "${timestamp} [\033[0;35mDEBUG\033[0m] [${pid}:${scriptName}] ${message}"
    fi

}

log_info() {
    local message=${1}
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # always log
    logger -t "${scriptName}" -p info "${message}"

    # if quite leave and dont log out to screen
    if [ $quiteMode == true ]; then
        return 0
    fi

    # log to screen
    echo -e "${timestamp} [\033[0;34mINFO\033[0m] [${pid}:${scriptName}] ${message}"
}

log_warn() {
    local message=${1}
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # always log
    logger -t "${scriptName}" -p warn "${message}"

    # if quite leave and dont log out to screen
    if [ $quiteMode == true ]; then
        return 0
    fi

    # log to screen
    echo -e "${timestamp} [\033[0;33mWARN\033[0m] [${pid}:${scriptName}] ${message}"
}

# create log on script log only
log_error() {
    local message=${1}
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # always log
    logger -t "${scriptName}" -p err "${message}"

    # we always output error

    # log to screen
    echo -e "${timestamp} [\033[0;31mERROR\033[0m] [${pid}:${scriptName}] ${message}" >&2
}

# if error detected stop exec
pFail() {
    local message=${1}
    local return_code=${2:-0}

    # turn logging on in failure
    quiteMode=false

    log_error "$message"
    exit "$return_code"
}

# if kill command recieved
pKill() {
    log_warn "end signal recieved cleaning up"
    exit 1
}

pCheckIsRoot() {
    if [[ ${EUID} -ne 0 ]]; then
        pFail "This script must be run as root!" 1
    fi
}

# used at start of script to initiate PABLO script run
pStart() {
    # stop script if error
    set -o errexit
    # fail if any command fails in pipeline
    set -o pipefail

    startTimeStamp=$(date +%s)
    # regex to check valid script name
    checkRegex="^[0-9a-zA-Z_-]+(\.sh)?$"

    # if script name is invalid fail TODO dont think this is needed
    if [[ ! ${scriptNameFull} =~ ${checkRegex} ]]; then
        pFail "PABLO: pStart failed: name script name invalid \"${scriptNameFull}\"" 1
    fi

    # delete retained outputs
    # find "${outputDir}" -type f -mtime +${outputRetention} -exec rm -f {} \;

    log_debug "PABLO STARTED: with PID \"${pid}\""

    # Cleanup on execution stop
    trap 'pCleanup $?' EXIT
    # If error log and cleanup
    trap 'pFail "Uncaught exception at line ${LINENO}" $?' ERR
    trap 'pKill' SIGINT SIGTERM
}

# cleans up resources on EXIT
pCleanup() {
    returnCode=${1:-0}
    # Remove temp files
    rm -f "${tmpDir}/*"
    rmRet=$?
    if [ $rmRet != 0 ]; then
        log_error "PABLO: unable to removing temporary files at \"$tmpDir\", rm returned \"$rmRet\""
    else
        log_debug "removed temporary files at \"$tmpDir\""
    fi

    finishTimeStamp=$(date +%s)
    totalExecTime=$(($finishTimeStamp - $startTimeStamp))

    log_info "finished execution in ${totalExecTime} secs (PID \"${pid}\")"
    log_info "return code: ${returnCode}"

    exit "$returnCode"
}


pCheckCommandAvail() {
    local cmd=${1}
    local message=${2:-"required command unavailable \"${cmd}\" please install and retry"}

    if command -v "${cmd}" > /dev/null; then
        log_debug "found command \"${cmd}\" found"
    else 
        pFail "${message}" 2
    fi
}

pCheckFileExist() {
    local file=${1}
    if [[ ! -f "${file}" ]]; then
        pFail "required file unavailable \"${file}\"" 2
    fi
}

pCheckFileNotExist() {
    local file=${1}
    if [[ -e "${file}" ]]; then
        pFail "file: \"${file}\", exists and should not"
    fi
}

pAskToContinue() {
    local msg=${1}
    local waitingforanswer=true
    while ${waitingforanswer}; do
        read -rp "${msg} (hit 'y/Y' to continue, 'n/N' to cancel) " -n 1 ynanswer
        case ${ynanswer} in
        [Yy])
            waitingforanswer=false
            break
            ;;
        [Nn])
            echo ""
            pKill
            ;;
        *)
            echo ""
            echo "Please answer either yes (y/Y) or no (n/N)."
            ;;
        esac
    done
    echo ""
}

# this adds to last line atm but most file probs need better handling
pAppendIfAbsent() {
    local str=${1}
    local file=${2}

    if grep -q "${str}" "${file}"; then
        log_info "\"${str}\" is in \"${file}\""
    else
        log_info "adding \"${str}\" to \"${file}\""
        sed -i "$ s/$/ ${str}/" "${file}"
    fi
}
