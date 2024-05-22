case "$OSTYPE" in
linux*) export DOTFILES_HOST="linux" ;;
darwin*) export DOTFILES_HOST="darwin" ;;
*) echo "OS or shell not supported." >&2 ;;
esac

export VISUAL=nvim
export EDITOR="$VISUAL"

# Bash specific variables
export FIGNORE="~:.:.."
export HISTSIZE=1000000
# TODO: something is causing the history file to be truncated on darwin.
export HISTCONTROL=ignorespace
export HISTIGNORE="l[asl]:rm *:exit:bg:fg:c:clear:c[dl]:pwd:.."
# Makes multi-line history work
export HISTTIMEFORMAT="%FT%H:%M:%S%z "

# Display italics instead of underlines in manpages.
export GROFF_SGR=1
export MANROFFOPT="-- -P-i"
# Don't justify or hyphenate man pages.
export MANOPT="--nj --nh"

# XDG base directory spec workarounds
# <https://wiki.archlinux.org/index.php/XDG_Base_Directory>
export GRADLE_USER_HOME="$HOME/.local/share/gradle"
export GOPATH="$HOME/.local/share/go"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
export TEXMFHOME="$HOME/.local/share/texmf"
export PARALLEL_HOME="$HOME/.config/parallel"
export UV_TOOL_BIN_DIR="$HOME/.local/autobin"
export MATHEMATICA_USERBASE="$HOME/.local/share/Wolfram"

# Telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# macOS settings
if [[ $DOTFILES_HOST == "darwin" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
fi

export PATH="$HOME/.local/bin:$HOME/.local/autobin:$PATH"

if [[ $DOTFILES_HOST == "darwin" ]]; then
    source ~/.bashrc
fi
