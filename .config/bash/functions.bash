# All my functions.

rejpeg() {
    if [ $# -eq 0 ]; then
        echo >&2 "No file name given."
        return 1
    fi
    if ! magick identify -format "%[profile:icc]" "$1" |&
        grep --fixed-strings "unknown image prop" >/dev/null; then
        echo "Image has embedded profile, so we are saving all metadata..." >&2
        jpegtran -copy all -outfile "${1%.*}-compressed.jpeg" "$1"
    else
        jpegtran -copy none -outfile "${1%.*}-compressed.jpeg" "$1"
    fi
}

n() {
    if [ "${NNNLVL:-0}" -ne 0 ]; then
        echo "nnn is already running"
        return
    fi

    local NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    NNN_TRASH=1 nnn -eo "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" >/dev/null
    fi
}

cl() {
    cd "$1" && ls
}
complete -d cl

shellescape() {
    printf %s\\n "$1" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/"
}

school() {
    spot="$(cd ~/Documents/syncthing/current_work && find . -type d |
        fzf --exact --height 50% --layout reverse)"
    cd ~/Documents/syncthing/current_work/"$spot"
}

timepdf() {
    # for editing pdf metadata ;)
    # format described in cpdfmanual.pdf
    b=$(date "+D:%Y%m%d%H%M%S%z")
    up_to_hour=${b:0:19}
    minute=${b:19}
    echo "${up_to_hour}'${minute}'"
}

abs() {
    if [ $# -ne 1 ]; then
        echo >&2 "No program given."
        return 1
    fi

    possible_program="$(command -v "$1")"

    if [ "$(printf %.1s "$possible_program")" != "/" ]; then
        echo "$possible_program"
        return 0
    fi

    realpath "$possible_program"
}
