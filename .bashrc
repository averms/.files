# https://unix.stackexchange.com/a/257613
[[ $- != *i* ]] && return

# Bash specific variables
FIGNORE="~:.:.."
HISTSIZE=1000000
HISTCONTROL=ignoreboth
HISTIGNORE="l[asl]:rm *:exit:bg:fg:c:clear:c[dl]:pwd:.."
# Makes multi-line history work
HISTTIMEFORMAT="%FT%H:%M:%S%z "

# Two stars will match any level of subdirectories.
shopt -s globstar
# Keep history from multiple parallel Bash instances.
shopt -s histappend
stty -ixon

if shopt -q login_shell && test -n "$SSH_TTY" -a -e /home/linuxbrew/.linuxbrew/bin/fish; then
    exec /home/linuxbrew/.linuxbrew/bin/fish
fi
