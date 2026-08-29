function __fish_unexpand_tilde --description 'Replace $HOME with "~"'
    # Match both what $HOME is set to and what it resolves to,
    # which handles users with symlinked HOMEs.
    set -l homes (string escape --style=regex -- ~ (path resolve -- ~))
    string replace -r -- "^(?:"(string join '|' $homes)")(\$|/)" '~$1' $argv
end
