# All my aliases.

if [[ $DOTFILES_HOST == "darwin" ]]; then
    alias ls="ls -p --color=auto"
    alias cp="cp -ipc"
    alias mk="make --jobs=$(($(sysctl -n hw.logicalcpu) - 1))"
    alias mv="mv -i"
    alias op="open"
    alias a="tar"

    alias brew="sudo -iu hb brew"
    alias bcheck="brew uses --recursive --installed"
else
    alias ls="ls -p --color=auto --literal"
    alias cp="cp --interactive --sparse=always"
    alias mk="make --jobs=$(($(nproc) - 1))"
    alias mv="mv --interactive"
    alias op="xdg-open"
    alias a="bsdtar"
    alias ip="ip -c=auto"


    alias ctl="systemctl"
    __load_completion systemctl
    complete -F _systemctl ctl

    # Don't use cache for user.
    alias dnf="dnf --cacheonly --nogpgcheck"
fi

# op is 1password's CLI and the bash-completion conflicts with our alias so we will give
# our own.
complete -o bashdefault -f op
# default make completion sucks
complete -o bashdefault -f make
# default tar completion is not great either
complete -o bashdefault -f tar

# the ls is supposed to expand
alias la="ls -A"
alias ll="ls -lh"

alias diff="diff --color=auto"
alias ..="cd .."
alias ...="cd ../.."
alias c="clear"
alias cdc="cd - >/dev/null"
alias info="info --vi-keys"
alias th="trash-put"
alias gp="grep --extended-regexp --color=auto --ignore-case"
alias e="nvim"
alias erc="nvim ~/.config/nvim/init.vim"
alias ffmpeg="ffmpeg -noauto_conversion_filters -hide_banner"
alias ffprobe="ffprobe -hide_banner"
alias mfo="\mediainfo"
alias dl="curl -fRLO"
alias gg="git status"
alias fnd="find . -type f"
alias hrg="rg --hidden --no-ignore"
alias notes="nvim ~/Documents/syncthing/wiki/Misc.md"

# python
alias dac="deactivate"

# dotfiles management
alias .f="git --git-dir=$HOME/.files --work-tree=$HOME"
alias .fls=".f ls-files --others"

# break habits
alias vim="echo 'Nope, use e.'"
alias mediainfo="echo 'Nope, use minfo instead.'"
alias apt="echo 'Nope, use nala instead.'"
