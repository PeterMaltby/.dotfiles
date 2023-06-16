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

alias ls='ls -lrth --color=auto'
alias lsa='ls -Alrth --color=auto'

defaults write .GlobalPreferences com.apple.mouse.scaling -1

PS1='%n%B@%F{9}%m%f%b %~ %(!.#.$) '
neofetch
