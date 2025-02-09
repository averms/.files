export VISUAL=nvim
export EDITOR="${VISUAL}"

# https://wiki.archlinux.org/index.php/XDG_Base_Directory
export GOPATH="${HOME}/.local/share/go"
export GRADLE_USER_HOME="${HOME}/.local/share/gradle"
export NPM_CONFIG_USERCONFIG="${HOME}/.config/npm/npmrc"
export PARALLEL_HOME="${HOME}/.config/parallel"
export TEXMFHOME="${HOME}/.local/share/texmf"
export WOLFRAM_USERBASE="${HOME}/.local/share/Wolfram"

# Display italics instead of underlines in manpages.
export GROFF_SGR=1
export MANROFFOPT="-- -P-i"
# Don't justify or hyphenate man pages.
export MANOPT="--nj --nh"

export SYSTEMD_TINT_BACKGROUND=0

# We want to keep ~/.local/bin for manually-installed tools.
export UV_TOOL_BIN_DIR="${HOME}/.cargo/bin"
export UV_PYTHON_DOWNLOADS=manual

# Telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

if [[ ${DOTFILES_HOST} = "linux" ]]; then
    export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
    export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
    export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
    export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}"
    [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}"

    export HOMEBREW_TEMP=/var/tmp
    ulimit -n hard
else
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
    [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

    # eval "$(flox activate -d ~ -m run)"
    # source "${FLOX_ENV}/etc/profile.d/bash_completion.sh"
fi

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
