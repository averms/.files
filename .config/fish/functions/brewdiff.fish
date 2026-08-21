function brewdiff
    diff -u (brew bundle list -g | sort | psub) (brew leaves | psub)
end
