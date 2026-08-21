if not status is-interactive
    exit
end

#
# Environment variables
#

set -gx VISUAL nvim
set -gx EDITOR $VISUAL

# https://wiki.archlinux.org/index.php/XDG_Base_Directory
set -gx XDG_CONFIG_HOME "$HOME/.config"  # needed by Homebrew

set -gx GOPATH "$HOME/.local/share/go"
set -gx GRADLE_USER_HOME "$HOME/.local/share/gradle"
set -gx NPM_CONFIG_USERCONFIG "$HOME/.config/npm/npmrc"
set -gx PARALLEL_HOME "$HOME/.config/parallel"
set -gx TEXMFHOME "$HOME/.local/share/texmf"
set -gx WOLFRAM_USERBASE "$HOME/.local/share/Wolfram"
set -gx SQLITE_HISTORY "$HOME/.local/state/sqlite_history"
set -gx RUSTUP_HOME "$HOME/.local/share/rustup"
set -gx PYTHON_HISTORY "$HOME/.local/state/python_history"
set -gx INPUTRC "$HOME/.config/readline/inputrc"
set -gx NODE_REPL_HISTORY "$HOME/.local/state/node_repl_history"
set -gx DOCKER_CONFIG "$HOME/.config/docker"
set -gx PI_CODING_AGENT_DIR "$HOME/.config/pi/agent"

# Display italics instead of underlines in manpages.
set -gx GROFF_SGR 1
set -gx MANROFFOPT "-- -P-i"
# Don't justify or hyphenate man pages.
set -gx MANOPT "--nj --nh"
# Don't ever tint terminal background.
set -gx SYSTEMD_TINT_BACKGROUND 0

# Claude
set -gx CLAUDE_CODE_DISABLE_TERMINAL_TITLE 1
set -gx DISABLE_ERROR_REPORTING 1
set -gx DISABLE_TELEMETRY 1

# We want to keep ~/.local/bin for manually-installed tools.
set -gx UV_TOOL_BIN_DIR "$HOME/.cargo/bin"
set -gx UV_PYTHON_DOWNLOADS manual
set -gx UV_PYTHON_PREFERENCE system
set -gx UV_PYTHON_INSTALL_BIN 0

# Telemetry
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

# Homebrew and OS-dependent configuration
if test (__fish_uname) = "Darwin"
    set -gx HOMEBREW_PREFIX "/opt/homebrew"
    set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX"
else
    set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
    set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"

    # Let docker-compose use Podman
    set -gx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/podman/podman.sock"
end

set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
fish_add_path -g --path --move \
    "$HOMEBREW_PREFIX/opt/rustup/bin" \
    "$HOMEBREW_PREFIX/bin" \
    "$HOMEBREW_PREFIX/sbin"
if not contains "$HOMEBREW_PREFIX/share/info" $INFOPATH
    set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH
end

set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS 1

fish_add_path -g --path "$HOME/.local/bin" "$HOME/.cargo/bin"

#
# Abbreviations and functions
#

if test (__fish_uname) = "Darwin"
    alias ls="ls --color=auto -F"
    alias cp="cp -ic"
    abbr -a op open
else
    alias ls="ls --color=auto --literal -F"
    alias cp="cp --interactive --sparse=always"
    abbr -a op xdg-open

    abbr -a --command "" --command sudo ctl systemctl
end

# shadowing programs
alias ffmpeg="ffmpeg -noauto_conversion_filters -hide_banner"
alias ffprobe="ffprobe -hide_banner"
alias diff="diff --color=auto"
alias info="info --vi-keys"
alias ip="ip -c=auto"
alias dua="DUA_FORMAT=metric command dua"
alias fd="fd --hidden --no-ignore-vcs --color=never"
alias mv="mv -i"

# the classics
alias ...="cd ../.."
alias a="bsdtar"
alias cdc="cd - >/dev/null"
alias cn="podman"
alias dl="curl -fRLJO"
alias e="nvim"
alias erc="nvim ~/.config/nvim/init.vim"
alias gg="git s"
alias gp="grep --extended-regexp --color=auto --ignore-case"
alias mfo="command mediainfo"
alias th="trash-put"

alias cnc="docker-compose"
alias obsid="nvim ~/Documents/syncthing/wiki/Index.md"
alias npi="NONO_TRUST_PROXY_CA=1 NONO_PROFILE=my-pi nono run --allow-cwd pi"

# dotfiles management
alias .f="git --git-dir=$HOME/.files"
alias .fls=".f ls-files --others"

# break habits
alias npm="false"
alias npx="false"
alias vim="false"

#
# General settings
#

set fish_autosuggestion_enabled 0
set fish_greeting
# Don't like the underline
set fish_pager_color_prefix normal
# needed by Homebrew
ulimit -n hard
