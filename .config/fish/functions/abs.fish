function abs
    argparse --min-args 1 --max-args 1 -- $argv
    or return 1

    if set resolved_command (command -v $argv[1])
        realpath $resolved_command
    else
        realpath $argv[1]
    end
end
