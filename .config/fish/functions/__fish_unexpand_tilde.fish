function __fish_unexpand_tilde --description 'Replace $HOME with "~"'
    set -l realhome (string escape --style=regex -- ~)
    # support symlinked HOMEs inside /var
    string replace -r -- "^(?:/var)?$realhome(\$|/)" '~$1' $argv
end
