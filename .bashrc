# .bashrc
# author: peterm
# created: 2023-04-28
#  ___    _    ___  _  _  ___   ___ 
# | _ )  /_\  / __|| || || _ \ / __|
# | _ \ / _ \ \__ \| __ ||   /| (__ 
# |___//_/ \_\|___/|_||_||_|_\ \___|
#                                   
#############################################################
# no out put if not interactive
[[ $- == *i* ]] || return
export PATH="$HOME/bin:$PATH"

# Environment vars
export I=~/infra
export S=~/scripts
export D=~/Downloads
export DT=~/Desktop
export G=~/gitrepos
export B=~/bin

export EDITOR=vim

export LANG="en_GB.UTF-8"
# alias scripts
alias mv='mv -i'
alias rm='rm -i'
alias ls='ls -lrh --group-directories-first --color=auto'
alias lsa='ls -Alrh --group-directories-first --color=auto'
alias lss='$B/fileSize'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

weather() { 
    clear
    curl wttr.in/Lincoln,+United+Kingdom 
}

# colours:
BLACK='\e[30m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'
RESET='\e[0m'
BRIGHT_RED='\e[91m'


# git prompt script
parse_git_branch() {
    gitBranch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [ "$?" != 0 ]; then
      return
    fi

    (&>/dev/null git fetch &)
    
    headHash=$(git rev-parse HEAD)
    upstreamHash=$(git rev-parse origin/${gitBranch}) 2> /dev/null
    if [ "$?" != 0 ]; then
      # assume that head is not tracking origin
      echo " (${MAGENTA}${gitBranch}${RESET})"
      return
    fi


    originHasLocalHash=$(git log origin/${gitBranch} | grep $headHash | wc -l)
    localHasOriginHash=$(git log | grep $upstreamHash | wc -l)
    gitStatus=$(git status --porcelain | wc -l)

    #echo "\n"
    #echo $originHasLocalHash
    #echo $localHasOriginHash
    #echo $gitStatus
    #echo "\n"

    if [ "$localHasOriginHash" -eq 0 ]; then
      # origin has work local does not
      echo -e " (${RED}${gitBranch}${RESET})"
    else
      if [ "$originHasLocalHash" -eq 0 ]; then
        # we have commits origin does not
        if [ "$gitStatus" -eq 0 ]; then
          # our branch is clean
          echo -e " (${GREEN}${gitBranch}${RESET})"
        else
          # we have local changes
          echo -e " (${BRIGHT_RED}${gitBranch}${RESET})"
        fi
      else
        if [ "$gitStatus" -eq 0 ]; then
          # our branch is clean
          echo -e " (${CYAN}${gitBranch}${RESET})"
        else
          # we have local changes
          echo -e " (${YELLOW}${gitBranch}${RESET})"
        fi
      fi
    fi

}


hostName=$(hostname)
hostRcPath="${HOME}/hosts/${hostName}.bash"

if [ -r ${hostRcPath} ]; then
    source ${hostRcPath}
else
    source ${HOME}/hosts/default.bash
fi

# for storing secret stuff i dont want git to know about
hostSecretRcPath="${hostRcPath}.secret"
if [ -r ${hostSecretRcPath} ]; then
    echo $hostSecretRcPath
    source ${hostSecretRcPath}
fi

unset hostName
unset hostRcPath
unset hostSecretRcPath
