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
export S=~/scripts
export D=~/Downloads
export DT=~/Desktop
export G=~/gitrepos

export EDITOR=vim
export HISTCONTROL=ignoreboth

# alias scripts
alias mv='mv -i'
alias rm='rm -i'
alias ls='ls -lrth --group-directories-first --color=auto'
alias lsa='ls -Alrth --group-directories-first --color=auto'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias vi="nvim"

weather() { curl wttr.in/Lincoln,+United+Kingdom }

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


hostName=$(hostname)
hostRcPath="${HOME}/hosts/${hostName}.zsh"

if [ -r ${hostRcPath} ]; then
	source ${hostRcPath}
else
	# i have to set each PS1 in host.zsh to set color if there is a better way to do this please let me know!
	PS1='%B%n%b@%F{1}%m%f %~ %(!.#.$) '
	echo "unrecognised host: $hostName"
fi

unset hostName
unset hostRcPath
