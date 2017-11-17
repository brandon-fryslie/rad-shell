bindkey '^[P' zaw-rad-proj

function zaw-src-rad-proj() {
    local title="projects"
    : ${(A)candidates::=$(cd "$PROJECTS_DIR" && ls -d */ | sed 's/\///g')}
    : ${(A)cand_descriptions::=$candidates}

    actions=(zaw-rad-proj-cd zaw-rad-proj-cd-edit zaw-rad-append-to-buffer)
    act_descriptions=("cd" "cd + edit" "append to buffer")

    options=(-t "$title" -m -k)
}

function zaw-rad-proj-cd() {
    zaw-rad-buffer-action "proj $1"
}

function zaw-rad-proj-cd-edit() {
    zaw-rad-buffer-action "proj $1 && ${VISUAL:-${EDITOR:-vi}} ."
}

zaw-register-src -n rad-proj zaw-src-rad-proj
