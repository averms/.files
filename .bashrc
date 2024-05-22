# https://unix.stackexchange.com/a/257613
[[ $- != *i* ]] && return

# Needs to be before distro bashrc on Fedora.
source ~/.config/bash/prompt.bash

[[ -f /etc/bashrc ]] && source /etc/bashrc
# Not interested in distro aliases and LS_COLORS.
unalias -a
unset -v LS_COLORS

if [[ $DOTFILES_HOST = "darwin" ]]; then
    source /opt/homebrew/etc/profile.d/bash_completion.sh
fi

source ~/.config/bash/fzf.bash
source ~/.config/bash/aliases.bash
source ~/.config/bash/functions.bash

shopt -s globstar
shopt -s histappend
stty -ixon
