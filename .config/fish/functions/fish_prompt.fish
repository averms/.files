function fish_prompt
    set -l last_pipestatus $pipestatus
    set -l normal (set_color normal)

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix "•"
    if fish_is_root_user
        set color_cwd $fish_color_cwd_root
    end

    # Figure out pipestatus
    set -l prompt_status ""
    switch $last_pipestatus[-1]
        # 0 means success and 141 is SIGPIPE
        # https://www.pixelbeat.org/programming/sigpipe_handling.html
        case 0 141
        case "*"
            set prompt_status ":( "
    end

    echo -n -s (prompt_login)" " (set_color $color_cwd) (prompt_pwd) $normal (set_color magenta) (fish_vcs_prompt) $normal (set_color $fish_color_status) " "$prompt_status $normal $suffix " "
end
