function zaw-rad-git-status-get-candidates() {
    git rev-parse --git-dir >/dev/null 2>&1
    [[ $? == 0 ]] || return $?
    local file_list="$(git status --porcelain)"
    local file_list_cands="$(echo $file_list | awk '{print $2}')"

    : ${(A)filter_select_candidates::=${(f)${file_list_cands}}}

    : ${(A)filter_select_descriptions::=${${(f)${file_list}}/ M /[modified]        }}
    : ${(A)filter_select_descriptions::=${${(M)filter_select_descriptions}/AM /[add|modified]    }}
    : ${(A)filter_select_descriptions::=${${(M)filter_select_descriptions}/MM /[staged|modified] }}
    : ${(A)filter_select_descriptions::=${${(M)filter_select_descriptions}/M  /[staged]          }}
    : ${(A)filter_select_descriptions::=${${(M)filter_select_descriptions}/A  /[staged(add)]     }}
    : ${(A)filter_select_descriptions::=${${(M)filter_select_descriptions}/ D /[deleted]         }}
    : ${(A)filter_select_descriptions::=${${(M)filter_select_descriptions}/UU /[conflict]        }}
    : ${(A)filter_select_descriptions::=${${(M)filter_select_descriptions}/AA /[conflict]        }}
    : ${(A)filter_select_descriptions::=${${(M)filter_select_descriptions}/\?\? /[untracked]       }}

    # echo "rad-git-status getting candidates: ${(j:,:)filter_select_candidates}" >> /tmp/zaw.log
}

function zaw-rad-git-status() {
    zaw-rad-git-status-get-candidates

    while true; do
        zaw-rad-git-status-get-candidates
        filter-select -f zaw-rad-git-status-get-candidates -m -M radgit -d filter_select_descriptions -e select-action -t "select file" -- "${(@)filter_select_candidates}"

        local action="${reply[1]}"

        [[ $action == 'select-action' ]] && break
    done

    BUFFER="git status"
    zaw-rad-action "${reply[1]}"
}

function rad-git-stage {
    git add "${FILTER_SELECT_SELECTED}" &>/dev/null
    # echo "staging file: ${FILTER_SELECT_SELECTED}" >> /tmp/zaw.log
}

zle -N rad-git-stage

function rad-git-unstage {
    git reset "${FILTER_SELECT_SELECTED}" &>/dev/null
    # echo "unstaging file: ${FILTER_SELECT_SELECTED}" >> /tmp/zaw.log
}

zle -N rad-git-unstage

function rad-git-stage-all {
    git add . &>/dev/null
    # echo "unstaging file: ${FILTER_SELECT_SELECTED}" >> /tmp/zaw.log
}

zle -N rad-git-stage-all

function rad-git-unstage-all {
    git reset . &>/dev/null
    # echo "unstaging file: ${FILTER_SELECT_SELECTED}" >> /tmp/zaw.log
}

zle -N rad-git-unstage-all

function _rad-git-init-keymap() {
    integer fd ret

    # be quiet and check filterselect keybind defined
    exec {fd}>&2 2>/dev/null
    bindkey -l radgit > /dev/null
    ret=$?
    exec 2>&${fd} {fd}>&-

    if (( ret != 0 )); then
        bindkey -N radgit
        bindkey -M radgit '^S' rad-git-stage
        bindkey -M radgit '^D' rad-git-unstage
        bindkey -M radgit '^[s' rad-git-stage-all
        bindkey -M radgit '^[d' rad-git-unstage-all
        bindkey -M radgit '^[d' rad-git-unstage-all
    fi
}

_rad-git-init-keymap
