source ~/Code/other/gitstatus/gitstatus.plugin.sh

PROMPT_DIRTRIM=2

__my_prompt() {
    local exit=$?
    local cyan='\[\e[36m\]'
    local reset='\[\e[0m\]'

    PS1=

    # user and trimmed path
    PS1+="‹\u \h \w› "

    # add virtual envs
    if [[ -n $VIRTUAL_ENV ]]; then
        PS1+="{python} "
    fi
    if [[ -n $PERL5LIB ]]; then
        PS1+="{perl} "
    fi
    if [[ -n $LUA_PATH ]]; then
        PS1+="{lua} "
    fi
    if [[ -n $CONDA_DEFAULT_ENV ]]; then
        PS1+="{conda} "
    fi

    # git stuff
    if gitstatus_query && [[ $VCS_STATUS_RESULT == ok-sync ]]; then
        PS1+="("

        local where # branch name, tag or commit
        if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
            where="$VCS_STATUS_LOCAL_BRANCH"
        elif [[ -n $VCS_STATUS_TAG ]]; then
            where="$VCS_STATUS_TAG"
        else
            where="$VCS_STATUS_COMMIT"
        fi
        PS1+="${where:0:8}"

        [[ $VCS_STATUS_HAS_STAGED -eq 1 ]] && PS1+="+"
        [[ $VCS_STATUS_HAS_UNSTAGED -eq 1 ]] && PS1+="!"
        [[ $VCS_STATUS_HAS_UNTRACKED -eq 1 ]] && PS1+="?"
        PS1+=") "
    fi

    # 0 means success and 148 means I pressed ctrl-z.
    # 141 is SIGPIPE somewhere in a pipeline:
    # https://www.pixelbeat.org/programming/sigpipe_handling.html.
    if ! [[ $exit -eq 0 || $exit -eq 148 || $exit -eq 141 ]]; then
        PS1+=":( "
    fi

    PS1+="${cyan}•${reset} "
}

# Start gitstatusd in the background.
gitstatus_stop && gitstatus_start -s -1 -u -1 -c -1 -d -1

PROMPT_COMMAND[0]=__my_prompt
