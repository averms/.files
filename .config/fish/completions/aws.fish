function __fish_aws_complete
    set -l token (commandline -xct)

    # Complete S3 URIs
    if string match -q 's3://*' -- $token
        __fish_aws_complete_s3_uri $token
        return
    end

    if __fish_seen_subcommand_from s3; and not __fish_prev_arg_in s3
        echo s3://
    end

    # If aws_completer has something to offer, take it
    set -lx COMP_LINE (commandline -pc)
    aws_completer 2>/dev/null | string match -r '.+'; and return

    # In contexts where we know local paths are probably not useful, return
    if __fish_seen_subcommand_from s3; and not __fish_seen_subcommand_from cp mv sync
        return
    end

    # Also complete local paths, which can be useful for many commands
    string match -qr '^\w+:(/|$)' -- $token; or __fish_complete_path (commandline -ct)
end

# Complete S3 URIs. This lists buckets and keys over the network when you
# press Tab. It does at most 1 list-objects-v2 call or 1 list-buckets call per Tab.
function __fish_aws_complete_s3_uri -a token
    set -l aws aws
    argparse --ignore-unknown profile= region= endpoint-url= -- (commandline -xpc) 2>/dev/null
    set -q _flag_profile; and set -a aws --profile $_flag_profile
    set -q _flag_region; and set -a aws --region $_flag_region
    set -q _flag_endpoint_url; and set -a aws --endpoint-url $_flag_endpoint_url

    set -l path (string replace s3:// '' -- $token | string split -m 1 /)
    if not set -q path[2]
        $aws s3api list-buckets --output text --query 'Buckets[].[Name]' 2>/dev/null |
            string replace -r '.+' 's3://$0/'
    else
        $aws s3api list-objects-v2 --bucket $path[1] --prefix "$path[2]" \
            --delimiter / --no-paginate --output text \
            --query '[CommonPrefixes[].[Prefix], Contents[].[Key]][]' 2>/dev/null |
            string replace -r '^' "s3://$path[1]/"
    end
end

complete -c aws -f -a "(__fish_aws_complete)"
