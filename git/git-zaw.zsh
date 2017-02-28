bindkey '^[G' zaw-rad-git


# idea for a plugin use:
# something to do with a branch

function zaw-src-rad-git() {
    local title="actions"
    local desc=(\
        add \
        commit \
        amend-commit \
        branches \
        log \
        fetch \
    )
    : ${(A)candidates::=${(@)desc}}
    : ${(A)cand_descriptions::=${(@)desc}}
    actions=(\
        zaw-src-rad-git-execute-action
    )
    options=(-t "$title")
}

function zaw-src-rad-git-execute-action() {
    zle -R
    eval "zaw-src-rad-git-$1"
}

function zaw-src-rad-git-add() {
    local cands
    local file_info="$(git status --porcelain 2>/dev/null)"
    local file_names=$(echo "$file_info" | awk '{print $2}')
    : ${(A)zaw_git_add_descriptions::=${(f)file_info}}
    : ${(A)cands::=${(f)file_names}}

    local reply=()
    filter-select -m -d zaw_git_add_descriptions -e select-action -t "select file" -- "${(@)cands}"
    [[ $? -eq 0 ]] || return $?

    [[ ${#reply_marked} -gt 0 ]] && selected_files="${reply_marked[@]}" || selected_files="${reply[2]}"

    BUFFER="git add ${selected_files}"
    zle "${reply[1]}"
}

function zaw-src-rad-git-commit() {
    BUFFER="git commit"
    zle accept-line
}

function zaw-src-rad-git-amend-commit() {
    BUFFER="git commit --amend"
    zle accept-line
}

function zaw-src-rad-git-branches() {
    zle zaw-git-branches
}

function zaw-src-rad-git-log() {
    BUFFER="git log"
    zle accept-line
}

function zaw-src-rad-git-fetch() {
    BUFFER="git fetch"
    zle accept-line
}

zaw-register-src -n rad-git zaw-src-rad-git
