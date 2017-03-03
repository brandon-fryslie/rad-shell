bindkey '^[G' zaw-rad-git

# idea for a plugin use:
# something to do with a branch

function zaw-src-rad-git() {
    local title="git commands"
    local desc=(\
        commit \
        log \
        fetch \
        status \
    )
    : ${(A)candidates::=${(@)desc}}
    : ${(A)cand_descriptions::=${(@)desc}}
    actions=(\
        zaw-rad-git-execute-action
    )
    options=(-t "$title")
}

function zaw-rad-git-execute-action() {
    zle -R
    eval "zaw-rad-git-$1"
}

# This sets global vars: reply, reply_marked
function zaw-rad-select-options() {
    local cands=(${(s: :)1})
    filter-select -m -d cands -e select-action -t "select options" -- "${(@)cands}"
    [[ $? -eq 0 ]] || zle send-break
}

function zaw-rad-git-commit() {
    BUFFER="git commit"
    local last_action="${reply[1]}"

    # Short circuit if they press enter
    [[ last_action == "accept-line" ]] && { zle accept-line; return }

    zaw-rad-select-options "--all --amend --patch --reset-author"

    # Collect selected options and append to buffer
    [[ ${#reply_marked} -gt 0 ]] && BUFFER+=" ${(j: :)reply_marked}"

    zaw-rad-action "${reply[1]}"
}

function zaw-rad-git-log() {
    BUFFER="git log"
    zaw-rad-action "${reply[1]}"
}

function zaw-rad-git-fetch() {
    BUFFER="git fetch"
    zaw-rad-action "${reply[1]}"
}

zaw-register-src -n rad-git zaw-src-rad-git
