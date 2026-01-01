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
pCheckCommandAvail raspiinfo "This script will only work on a rasberry pi"

# Enable cgroups for k3s 
pCheckFileExist ${cmdline}

pAppendIfAbsent "cgroups_memory=1" ${cmdline}
pAppendIfAbsent "cgroup_enable=memory" ${cmdline}

