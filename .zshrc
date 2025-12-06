# .zshrc
# created: 08-10-2022
#	 ______  _____  _    _  _____    _____ 
#	|___  / / ____|| |  | ||  __ \  / ____|
#	   / / | (___  | |__| || |__) || |     
#	  / /   \___ \ |  __  ||  _  / | |     
#	 / /__  ____) || |  | || | \ \ | |____ 
#	/_____||_____/ |_|  |_||_|  \_\ \_____|
###################################################################
# Environment vars
export I=~/infra
export S=~/scripts
export D=~/Downloads
export DT=~/Desktop
export G=~/gitrepos

export EDITOR=vim
export HISTCONTROL=ignoreboth

export LANG="en_GB.UTF-8"
# alias scripts
alias mv='mv -i'
alias rm='rm -i'
alias ls='ls -lrh --group-directories-first --color=auto'
alias lsa='ls -Alrh --group-directories-first --color=auto'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias vi="\vim"
alias vim="\nvim"
alias wiki="cd ~/peter-wiki/"

weather() { 
    clear
    curl wttr.in/Lincoln,+United+Kingdom 
}

# ZSH config
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep
bindkey -v

# autocomplete
autoload -Uz compinit
compinit
# autocomplete hidden files
_comp_options+=(globdots)

# git prompt script
parse_git_branch() {
    gitBranch=$(git rev-parse --abbrev-ref HEAD) 2> /dev/null
    if [ "$?" != 0 ]; then
      return
    fi

    (&>/dev/null git fetch &)
    
    headHash=$(git rev-parse HEAD)
    upstreamHash=$(git rev-parse origin/${gitBranch}) 2> /dev/null
    if [ "$?" != 0 ]; then
      # assume that head is not tracking origin
      echo " (%F{5}${gitBranch}%f)"
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
      echo " (%F{1}${gitBranch}%f)"
    else
      if [ "$originHasLocalHash" -eq 0 ]; then
        # we have commits origin does not
        if [ "$gitStatus" -eq 0 ]; then
          # our branch is clean
          echo " (%F{2}${gitBranch}%f)"
        else
          # we have local changes
          echo " (%F{9}${gitBranch}%f)"
        fi
      else
        if [ "$gitStatus" -eq 0 ]; then
          # our branch is clean
          echo " (%F{6}${gitBranch}%f)"
        else
          # we have local changes
          echo " (%F{3}${gitBranch}%f)"
        fi
      fi
    fi

}


hostName=$HOST
hostRcPath="${HOME}/hosts/${hostName}.zsh"

if [ -r ${hostRcPath} ]; then
	source ${hostRcPath}
else
	# i have to set each PS1 in host.zsh to set color if there is a better way to do this please let me know!
	PS1='%B%n%b@%F{1}%m%f %~ %(!.#.$) '
	echo "unrecognised host: $hostName"
fi

# for storing secret stuff i dont want git to know about
hostSecretRcPath="${hostRcPath}.secret"

if [ -r ${hostSecretRcPath} ]; then
    source ${hostSecretRcPath}
fi

unset hostName
unset hostRcPath

# tf
alias tf='terraform'

