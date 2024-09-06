# homeArch.zsh
# author: peterm
# created: 2023-04-21
#  _  _   ___   __  __  ___    _    ___   ___  _  _     ____ ___  _  _ 
# | || | / _ \ |  \/  || __|  /_\  | _ \ / __|| || |   |_  // __|| || |
# | __ || (_) || |\/| || _|  / _ \ |   /| (__ | __ | _  / / \__ \| __ |
# |_||_| \___/ |_|  |_||___|/_/ \_\|_|_\ \___||_||_|(_)/___||___/|_||_|
#                                                                      
#############################################################

path+=('/home/peterm/.cargo/bin') 
export PATH

parse_git_branch() {

    gitStatus=$(git status --porcelain | wc -l) 2> /dev/null

    if [ "$gitStatus" -eq 0 ]; then
      git symbolic-ref --short HEAD 2> /dev/null | sed -E 's/(.+)/ (%F{2}\1%f)/g'
    else
      git symbolic-ref --short HEAD 2> /dev/null | sed -E 's/(.+)/ (%F{3}\1%f)/g'
    fi

}

setopt prompt_subst

prompt='%n%B@%F{4}%m%f%b %~$(parse_git_branch) %(!.#.$) '
neofetch --ascii_colors 4 4 --colors 4 12 13 13 13 12
