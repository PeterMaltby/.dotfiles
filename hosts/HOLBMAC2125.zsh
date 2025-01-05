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

# k9s
alias k9sp='k9s --context aks-prod-cluster'
alias k9sn='k9s --context aks-nprd-cluster'

export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=true
