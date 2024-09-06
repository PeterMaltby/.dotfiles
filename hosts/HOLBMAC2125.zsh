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

parse_git_branch() {

    gitStatus=$(git status --porcelain | wc -l) 2> /dev/null

    if [ "$gitStatus" -eq 0 ]; then
      git symbolic-ref --short HEAD 2> /dev/null | sed -E 's/(.+)/ (%F{2}\1%f)/g'
    else
      git symbolic-ref --short HEAD 2> /dev/null | sed -E 's/(.+)/ (%F{3}\1%f)/g'
    fi

}

setopt prompt_subst

prompt='%n%B@%F{9}%m%f%b %~$(parse_git_branch) %(!.#.$) '
neofetch

# volta stuff
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# deno
export DENO_INSTALL="/Users/peter.maltby1/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# tf
alias tf='terraform'

export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=true
