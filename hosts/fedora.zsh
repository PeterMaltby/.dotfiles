# homeArch.zsh
# author: peterm
# created: 2023-04-21
#############################################################

setopt prompt_subst

prompt='%n%B@%F{5}%m%f%b %~$(parse_git_branch) %(!.#.$) '
fastfetch --color magenta --logo-color-1 magenta --logo-color-2 white
