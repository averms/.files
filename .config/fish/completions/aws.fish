function __fish_aws_complete
    # If aws_completer has something to offer, take it
    set -lx COMP_LINE (commandline -pc)
    aws_completer 2>/dev/null | string match -r '.+'; and return

    if __fish_seen_subcommand_from s3; and not __fish_seen_subcommand_from cp mv sync
        return
    end

    # Also complete local paths, which can be useful for many commands
    string match -qr '^\w+:(/|$)' -- (commandline -xct); or __fish_complete_path (commandline -ct)
end

complete -c aws -f -a "(__fish_aws_complete)"

# Complete s3:// URIs. This lists buckets and keys over the network when you
# press Tab. It does at most 1 list-objects-v2 call or 1 list-buckets call per Tab.

function __fish_aws_complete_s3_uri
    set -l aws aws
    argparse --ignore-unknown profile= region= endpoint-url= -- (commandline -xpc) 2>/dev/null
    for opt in profile region endpoint-url
        set -l flag _flag_(string replace - _ $opt)
        set -q $flag; and set -a aws --$opt $$flag
    end

    set -l path (commandline -xct | string replace s3:// '' | string split -m 1 /)
    if not set -q path[2]
        for bucket in ($aws s3api list-buckets --output text --query 'Buckets[].[Name]' 2>/dev/null)
            echo s3://$bucket/
        end
    else
        for key in ($aws s3api list-objects-v2 --bucket $path[1] --prefix "$path[2]" \
                --delimiter / --no-paginate --output text \
                --query '[CommonPrefixes[].[Prefix], Contents[].[Key]][]' 2>/dev/null)
            echo s3://$path[1]/$key
        end
    end
end

set -l typed "string match -q 's3://*' -- (commandline -xct)"
complete -c aws -f -n "__fish_seen_subcommand_from s3" -n "not __fish_prev_arg_in s3" -n "not $typed" -a s3://
complete -c aws -f -n $typed -a "(__fish_aws_complete_s3_uri)"
