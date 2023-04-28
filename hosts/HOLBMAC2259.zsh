# HOLBMAC2259.zsh
# author: peterm
# created: 2023-04-21
#  _  _   ___   _     ___  __  __    _    ___  ___  ___  ___  ___    ____ ___ 
# | || | / _ \ | |   | _ )|  \/  |  /_\  / __||_  )|_  )| __|/ _ \  |_  // __|
# | __ || (_) || |__ | _ \| |\/| | / _ \| (__  / /  / / |__ \\_, /_  / / \__ \
# |_||_| \___/ |____||___/|_|  |_|/_/ \_\\___|/___|/___||___/ /_/(_)/___||___/
#                                                                             
#  _  _ 
# | || |
# | __ |
# |_||_|
#       
#############################################################
# machine specific zshrc

alias ls=$(ls -lrth --color=auto)
alias lsa=$(ls -lArth --color=auto)

export GROOVY_HOME=/opt/homebrew/opt/groovy/libexec
alias j17="export JAVA_HOME=$(/usr/libexec/java_home -v 17.0.5) ; java -version"
alias j18="export JAVA_HOME=$(/usr/libexec/java_home -v 18.0.2.1) ; java -version"
alias j19="export JAVA_HOME=$(/usr/libexec/java_home -v 19.0.1) ; java -version"


defaults write .GlobalPreferences com.apple.mouse.scaling -1

PS1='%n%B@%F{9}%m%f%b %~ %(!.#.$) '
neofetch
