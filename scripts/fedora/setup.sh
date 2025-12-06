#!/bin/bash
# setup.sh
# author: peterm
# created: 2025-12-06
#############################################################
source "$S/PABLO.sh"

#############################################################
pStart

if ! command -v dnf >/dev/null 2>&1
then
	pLog "dnf dot detcetd are you sure this is fedora?"
	exit 1
fi

pLog "checking for updates"
dnf check-update

pLog "installing any updates"
sudo dnf update

pLog "checking for updates"
sudo dnf install zsh \
				fastfetch \
				htop \
				neovim \
				vim \
				alacritty \

if [ "$SHELL" = "/bin.zsh" ]
then
	pLog "zsh: current shell"
	sudo dnf install zsh

else
	pLog "changeShell to zsh"
	chsh -s $(which zsh)
fi


pEnd
