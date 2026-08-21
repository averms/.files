function fish_should_add_to_history
    set -l cmd_line $argv[1]

    switch $cmd_line
        case bg fg cd exit "rm *" " *"
            return 1
    end

    return 0
end
