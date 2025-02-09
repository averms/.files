case "${OSTYPE}" in
linux*) export DOTFILES_HOST="linux" ;;
darwin*) export DOTFILES_HOST="macos" ;;
*)
    echo "OS or shell not supported." >&2
    return
    ;;
esac

. ~/.bashrc
