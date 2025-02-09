# All my aliases.

if [[ ${DOTFILES_HOST} == "linux" ]]; then
    alias ls="ls -p --color=auto --literal"
    alias cp="cp --interactive --sparse=always"
    alias mv="mv --no-copy --interactive"
    alias op="xdg-open"
    alias a="bsdtar"

    alias lbrew="sudo -iu linuxbrew brew"
    alias ip="ip -c=auto"
    # alias enter="toolbox run kitten run-shell"
    # alias enter='cn exec -it --user anon --workdir "/run/host${PWD}" --env DISPLAY="${DISPLAY}" fedbox bash -l -c "kitten run-shell"'

    # ~/.local/bin/ctl
    __load_completion systemctl
    complete -F _systemctl ctl
else
    alias ls="ls -p --color=auto"
    alias cp="cp -ipc"
    alias mv="mv -i"
    alias op="open"
    alias a="tar"
fi

# op is 1password's CLI so we will override bash-completion's definitions
complete -o bashdefault -f op
# default make completion sucks
complete -o bashdefault -f make
# default tar completion is not great either
complete -o bashdefault -f tar


# shadowing programs
alias ffmpeg="ffmpeg -noauto_conversion_filters -hide_banner"
alias ffprobe="ffprobe -hide_banner"
alias diff="diff --color=auto"
alias info="info --vi-keys"

# the classics
alias la="ls -A"
alias ll="ls -lh"
alias ..="cd .."
alias ...="cd ../.."
alias c="clear"
alias cdc="cd - >/dev/null"
alias th="trash-put"
alias gp="grep --extended-regexp --color=auto --ignore-case"
alias e="nvim"
alias erc="nvim ~/.config/nvim/init.vim"
alias dl="curl -fRLO"
alias gg="git status"
alias fd="fd --color=never"
alias hrg="rg --hidden --no-ignore"
alias notes="nvim ~/Documents/syncthing/wiki/Misc.md"
alias mfo="command mediainfo"

alias cn="command podman"
__load_completion podman
complete -o default -F __start_podman cn

# python
alias dac="deactivate"

# dotfiles management
alias .f="git --git-dir=${HOME}/.files --work-tree=${HOME}"
alias .fls=".f ls-files --others"

# break habits
alias mediainfo="false"
alias podman="false"
alias vim="false"
