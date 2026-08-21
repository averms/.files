function fish_vcs_prompt
    set -l git_info (command git --no-optional-locks status --porcelain=v2 --branch --show-stash --ignore-submodules --untracked-files=no 2>/dev/null | __git_status_parse | string split0)
    if test "$pipestatus[1]" -ne 0
        return
    end

    set -l is_dirty $git_info[1]
    set -l is_staged $git_info[2]
    set -l has_stash $git_info[3]
    set -l ref_name $git_info[4]
    set -l upstream $git_info[5]

    set -l symbol
    if test "$is_dirty" -eq 1
        set -a symbols "?"
    end
    if test "$is_staged" -eq 1
        set -a symbols "+"
    end
    if test "$has_stash" -eq 1
        set -a symbols "⚑"
    end

    echo -s " {" $ref_name $symbols "}"
end

function __git_status_parse
    set -l is_dirty 0
    set -l is_staged 0
    set -l has_stash 0
    set -l commit_hash
    set -l full_branch_name
    set -l upstream "none"

    while read -l line
        if string match -q '# branch.head *' -- $line
            set full_branch_name (string replace '# branch.head ' '' -- $line)
        else if string match -q '# branch.oid *' -- $line
            set commit_hash (string replace '# branch.oid ' '' -- $line)
        else if string match -q '# branch.ab *' -- $line
            set -l ab (string replace '# branch.ab ' '' -- $line)
            if test "$ab" = "+0 -0"
                set upstream "equal"
            else if string match -q '+0 *' -- $ab
                set upstream "behind"
            else if string match -q '* -0' -- $ab
                set upstream "ahead"
            else
                set upstream "diverged"
            end
        else if string match -q '# stash *' -- $line
            set has_stash 1
        else if string match -qr '^[12] ' -- $line
            set -l x (string sub -s 3 -l 1 -- $line)
            set -l y (string sub -s 4 -l 1 -- $line)
            if test "$x" != "."
                set is_staged 1
            end
            if test "$y" != "."
                set is_dirty 1
            end
        end

        # early exit
        if test "$is_staged" -eq 1 -a "$is_dirty" -eq 1
            break
        end
    end

    set -l ref_name
    if test "$full_branch_name" = "(detached)" -o -z "$full_branch_name"
        if test -n "$commit_hash"
            set ref_name (string sub -l 7 -- $commit_hash)
        else
            set ref_name "error: unknown"
        end
    else
        set ref_name $full_branch_name
    end

    string join0 -- $is_dirty $is_staged $has_stash $ref_name $upstream
end
