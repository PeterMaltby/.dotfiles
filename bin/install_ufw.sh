#!/usr/bin/env bash
# install_ufw.sh
# author: peterm
# created: 2026-01-02
#############################################################
source "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/PABLO.sh"

ufw_confg=/etc/default/ufw
#############################################################
pStart
pCheckIsRoot

pCheckCommandAvail ufw "please install ufw for this script"
pCheckFileExist ${ufw_confg}

# disbale ufw first
ufw disable

# should alws deny by default
ufw default deny

# disable ipv6
# modify /etc/default/ufw and change IPV6 to = no

# allow ssh so we dont lock ourselves out
ufw allow 22

# limit ssh to stop bruteforce
ufw limit 22


