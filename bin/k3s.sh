#!/usr/bin/env bash
# k3s.sh
# author: peterm
# created: 2026-01-01
#############################################################
source "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/PABLO.sh"

cmdline=/boot/firmware/cmdline.txt
#############################################################
# rasberry pi k3s installer
#############################################################
pStart

pCheckIsRoot

# dirty check for raspberry pi
check_command raspiinfo "This script will only work on a rasberry pi"

# Enable cgroups for k3s 
check_file_exists ${cmdline}

append_if_absent() {
    local str=${1}
    local file=${2}

    if grep -q "${str}" "${file}"; then
        log_info "\"${str}\" is in \"${file}\""
    else
        log_info "adding \"${str}\" to \"${file}\""
        sed -i "$ s/$/ ${str}/" "${file}"
    fi
}

append_if_absent "cgroups_memory=1" ${cmdline}
append_if_absent "cgroup_enable=memory" ${cmdline}

