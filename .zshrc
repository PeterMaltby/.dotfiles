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
alias ls='ls -lrth'


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

host=`hostname`
case $host in
'homeArch')
	PS1='%n%B@%F{4}%m%f%b %~ %(!.#.$) '

	wttr() { curl wttr.in/Lincoln,+United+Kingdom }
	alias ls='ls -lrth --group-directories-first --color=auto'

	neofetch --ascii_colors 4 4 --colors 4 12 13 13 13 12

	PATH=$PATH:$HOME/.cargo/bin
	;;
'HOLBMAC2259')
	PS1='%n%B@%F{9}%m%f%b %~ %(!.#.$) '

	alias ls='ls -lrth --color=auto'
	wttr() { curl wttr.in/Lincoln,+United+Kingdom }

 	export GROOVY_HOME=/opt/homebrew/opt/groovy/libexec
 	alias j17="export JAVA_HOME=$(/usr/libexec/java_home -v 17.0.5) ; java -version"
 	alias j18="export JAVA_HOME=$(/usr/libexec/java_home -v 18.0.2.1) ; java -version"
 	alias j19="export JAVA_HOME=$(/usr/libexec/java_home -v 19.0.1) ; java -version"
 	defaults write .GlobalPreferences com.apple.mouse.scaling -1

	neofetch
	;;
'dobsd')
	PS1='%n%B@%F{3}%m%f%b %~ %(!.#.$) '

	neofetch
	;;
'do-rocky')
	PS1='%n%B@%F{14}%m%f%b %~ %(!.#.$) '

	neofetch
	;;
*)
	PS1='%B%n%b@%F{1}%m%f %~ %(!.#.$) '
	echo "unrecognised host: $host"
	;;
esac
