# .bashrc
# author: peterm
# created: 2023-04-28
#  ___    _    ___  _  _  ___   ___ 
# | _ )  /_\  / __|| || || _ \ / __|
# | _ \ / _ \ \__ \| __ ||   /| (__ 
# |___//_/ \_\|___/|_||_||_|_\ \___|
#                                   
#############################################################
# Environment vars
export G=~/gitrepos
export S=~/scripts

export EDITOR=vim

# alias scripts
alias mv='mv -i'
alias rm='rm -i'
alias ls='ls -lrth --group-directories-first --color=auto'
alias lsa='ls -Alrth --group-directories-first --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

hostName=$(hostname)
hostRcPath="${HOME}/hosts/${hostName}.bash"

if [ -r "${hostRcPath}" ]; then
    source "${hostRcPath}"
else
    source "${HOME}/hosts/default.bash"
fi

unset hostName
unset hostRcPath
