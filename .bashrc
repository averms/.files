# https://unix.stackexchange.com/a/257613
[[ $- != *i* ]] && return

# Bash specific variables
FIGNORE="~:.:.."
HISTSIZE=1000000
HISTCONTROL=ignoreboth
HISTIGNORE="l[asl]:rm *:exit:bg:fg:c:clear:c[dl]:pwd:.."
# Makes multi-line history work
HISTTIMEFORMAT="%FT%H:%M:%S%z "

source ~/.config/bash/environment.bash

# Completion slows down startup time a lot but it's worth it.
source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"

# Needs to be before distro bashrc on Fedora.
source "${HOMEBREW_PREFIX}/share/powerlevel10k/gitstatus/gitstatus.plugin.sh"
source ~/.config/bash/prompt.bash
source ~/.config/bash/fzf.bash
source ~/.config/bash/aliases.bash
source ~/.config/bash/functions.bash

export PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:${PATH}"

# Two stars will match any level of subdirectories.
shopt -s globstar
# Keep history from multiple parallel Bash instances.
shopt -s histappend
stty -ixon
