function fish_user_key_bindings
    # fzf
    set -g FZF_CTRL_T_COMMAND "fd --hidden"
    set -g FZF_ALT_C_COMMAND "fd --type dir --hidden"
    FZF_CTRL_R_COMMAND= source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.fish"

    # i don't use it and it conflicts with my kitty binds
    bind --erase --preset ctrl-x
end
