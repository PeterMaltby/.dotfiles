#!/usr/bin/env bash
# PABLO.sh
# created: 2022-10-08
# bash utilities
# -v for verbose logs
############################################################
if [[ -n "${PABLO_LOADED}" ]]; then
    pError "PABLO ALREADY RUNNING"
    exit 1
fi
readonly PABLO_LOADED=1

SCRIPT_NAME_FULL=${0##*/}
SCRIPT_NAME=$(echo "${0##*/}" | cut -d. -f1)
PID=$$

# logLevel changed with --verbose and --quite flags
# 0 = all and debug
# 1 = all and stacktrace on error
# 2 = warning and error only
# 3 = error only
PABLO_LOG_LEVEL=2

# should be where script file is in my bin
BIN_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# For temporary files related to script
TEMP_DIR=/tmp/pablo
# input dir for script inputs
INPUT_DIR="${BIN_DIR}/input/${SCRIPT_NAME}"

# ensures dirs are created
mkdir -p "${INPUT_DIR}"
mkdir -p "${TEMP_DIR}"

# Usage: log_debug "my message here"
log_debug() {
    local message=${1}
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # always log
    logger -t "${SCRIPT_NAME}" -p debug "${message}"

    if [ "$PABLO_LOG_LEVEL" -lt 1 ]; then
        # log to screen
        echo -e "${timestamp} [\033[0;35mDEBUG\033[0m] [${PID}:${SCRIPT_NAME}] ${message}"
    fi

}

# Usage: log_info "my message here"
log_info() {
    local message=${1}
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # always log
    logger -t "${SCRIPT_NAME}" -p info "${message}"

    if [ "$PABLO_LOG_LEVEL" -lt 2 ]; then
        echo -e "${timestamp} [\033[0;34mINFO\033[0m] [${PID}:${SCRIPT_NAME}] ${message}"
    fi

}

# Usage: log_warn "my message here"
log_warn() {
    local message=${1}
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # always log
    logger -t "${SCRIPT_NAME}" -p warn "${message}"

    if [ "$PABLO_LOG_LEVEL" -lt 3 ]; then
        echo -e "${timestamp} [\033[0;33mWARN\033[0m] [${PID}:${SCRIPT_NAME}] ${message}"
    fi

}

# Usage: log_error "my message here"
log_error() {
    local message=${1}
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    logger -t "${SCRIPT_NAME}" -p err "${message}"

    # dont know why youd ever not want this but here anyway
    if [ "$PABLO_LOG_LEVEL" -lt 4 ]; then
        echo -e "${timestamp} [\033[0;31mERROR\033[0m] [${PID}:${SCRIPT_NAME}] ${message}" >&2
    fi

}

# if error detected stop exec
# Usage handle_error "message" 1
handle_error() {
    local message=${1}
    local return_code=${2:-1}

    log_error "$message"

    if [[ ${#BASH_SOURCE[@]} -gt 1 && ${PABLO_LOG_LEVEL} -lt 2 ]]; then
        log_error "Stack trace:"
        local i=0
        while [[ $i -lt ${#BASH_SOURCE[@]} ]]; do
            if [[ $i -gt 0 ]]; then
                log_error "  [$i] ${BASH_SOURCE[$i]}:${BASH_LINENO[$((i - 1))]} in ${FUNCNAME[$i]}"
            fi
            ((i++))
        done
    fi

    echo -e ""
    echo -e "To view full logs of this run: \"jorunalctl -t ${SCRIPT_NAME}\""
    echo -e ""

    exit "$return_code"
}

# if kill command recieved
pKill() {
    log_warn "end signal recieved cleaning up"
    exit 1
}

# usage: check_is_root
check_is_root() {
    log_debug "checking if root"
    if [[ ${EUID} -ne 0 ]]; then
        handle_error "This script must be run as root!" 5
    fi
}

# used at start of script to initiate PABLO script run
# Usage: pStart "$@"
pStart() {
    startTimeStamp=$(date +%s)
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    while [[ $# -gt 0 ]]; do
        case $1 in
        -v | --verbose)
            PABLO_LOG_LEVEL=1
            shift
            ;;
        -vv | --very-verbose | --debug)
            PABLO_LOG_LEVEL=0
            shift
            ;;
        -q | --quite)
            PABLO_LOG_LEVEL=3
            shift
            ;;
        *)
            shift
            ;;
        esac
    done

    log_info "Log Level = \"${PABLO_LOG_LEVEL}\""

    # stop script if error
    set -o errexit
    # fail if any command fails in pipeline
    set -o pipefail

    # regex to check valid script name
    checkRegex="^[0-9a-zA-Z_-]+(\.sh)?$"

    # if script name is invalid fail TODO dont think this is needed
    if [[ ! ${SCRIPT_NAME_FULL} =~ ${checkRegex} ]]; then
        handle_error "PABLO: pStart failed: name script name invalid \"${SCRIPT_NAME_FULL}\"" 1
    fi

    # delete retained outputs
    # find "${outputDir}" -type f -mtime +${outputRetention} -exec rm -f {} \;

    log_debug "PABLO started at $timestamp, with args \"$#\" PID \"${PID}\""
    # Cleanup on execution stop
    trap 'pCleanup $?' EXIT
    # If error log and cleanup
    trap 'handle_error "Uncaught exception at line $LINENO" $?' ERR
    trap 'pKill' SIGINT SIGTERM
}

# cleans up resources on EXIT
pCleanup() {
    returnCode=${1:-0}
    log_debug "cleanup running"
    # Remove temp files
    rm -f "${TEMP_DIR}/*"
    rmRet=$?
    if [ $rmRet != 0 ]; then
        log_error "PABLO: unable to removing temporary files at \"$TEMP_DIR\", rm returned \"$rmRet\""
    else
        log_debug "removed temporary files at \"$TEMP_DIR\""
    fi

    finishTimeStamp=$(date +%s)
    totalExecTime=$(($finishTimeStamp - $startTimeStamp))

    log_info "finished execution in ${totalExecTime} secs (PID \"${PID}\")"
    log_info "return code: ${returnCode}"

    exit "$returnCode"
}

# Usage: check_command_avail command || exit 1
check_command_avail() {
    local cmd=${1}
    local message=${2:-"required command unavailable \"${cmd}\" please install and retry"}
    log_debug "checking if command \"$cmd\" exist"

    if command -v "${cmd}" >/dev/null; then
        log_debug "command \"${cmd}\" found"
        return 0
    else
        return 1
    fi
}

# Usage: check_file_exists /path || exit 1
check_file_exists() {
    local file=${1}
    log_debug "checking if file \"$file\" exist"
    if [[ ! -f "$file" ]]; then
        log_error "required file unavailable \"${file}\"" 2
    fi
}

# Usage: check_file_not_exists /path || exit 1
check_file_not_exists() {
    local file=${1}
    log_debug "checking if file \"$file\" does not exist"
    if [[ -e "${file}" ]]; then
        log_error "file: \"${file}\", exists and should not"
    fi
}

# Usage ask_to_continue "delete all files"
ask_to_continue() {
    local msg=${1}
    local waitingforanswer=true

    log_debug "asking to continue"

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
    # new line
    echo ""
}

# Usage: replace_file "/soruce/file" "/dest/file"
replace_file() {
    local source="$1"
    local dest="$2"

    log_debug "Copying \"$source\" to \"$dest\""

    check_file_exists "$source" || {
        log_error "Source file of move operation does not exsist \"$source\""
        return 1
    }

    if [[ -f "$dest" ]]; then
        local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        local backup="${dest}.backup.${timestamp}"
        log_info "Created backup of dest file: \"$backup\""
        cp -p "$dest" "$backup" || handle_error "failed to create backup \"cp -p $dest $backup\"" 3
    fi

    cp -p "$dest" "$dest" || handle_error "failed to copy file \"cp -p $source $dest\"" 3

    log_info "Copied \"$source\" \"$dest\""
    return 0

}
