bindkey '^[<' zaw-rad-docker-image

function zaw-src-rad-docker-image() {
    title="$(docker images | head -n 1)"
    desc="$(docker images | tail +2)"
    : ${(A)candidates::=${(f)desc}}
    actions=(\
        zaw-rad-docker-image-run \
        zaw-rad-docker-image-push \
        zaw-rad-docker-image-pull \
        zaw-rad-docker-image-inspect \
        zaw-rad-docker-image-history \
        zaw-rad-docker-image-rmi \
        zaw-rad-docker-image-tag \
        zaw-rad-docker-image-append-name-to-buffer \
        zaw-rad-docker-image-append-id-to-buffer \
    )
    act_descriptions=(\
        "run" \
        "push" \
        "pull" \
        "inspect" \
        "history" \
        "rmi" \
        "tag" \
        "append name to buffer" \
        "append id to buffer" \
    )
    options=(-t "$title" -m)
}

# Helper functions

# Extract repo from `docker image` output
function zaw-rad-docker-image-extract-repo() {
    echo $1 | awk '{print $1}'
}

# Extract tag from `docker image` output
function zaw-rad-docker-image-extract-tag() {
    echo $1 | awk '{print $2}'
}

# Extract id from `docker image` output
function zaw-rad-docker-image-extract-id() {
    echo $1 | awk '{print $3}'
}

# Extract unique identifier, either $repo:$tag or $id (if no tag)
function zaw-rad-docker-image-extract-fullname() {
    local repo tag id
    repo="$(zaw-rad-docker-image-extract-repo $1)"
    tag="$(zaw-rad-docker-image-extract-tag $1)"
    id="$(zaw-rad-docker-image-extract-id $1)"

    [[ $tag == '<none>' ]] && echo "$id" || echo "$repo:$tag"
}

# Perform buffer action with multiple images
function zaw-rad-docker-image-multiselect-action() {
    local cmd=$1
    local images=()
    for i ($selected) images+="$(zaw-rad-docker-image-extract-fullname "$i")"
    zaw-rad-buffer-action "$cmd ${(j: :)images}"
}

# Command functions

function zaw-rad-docker-image-run() {
    zaw-rad-buffer-action "docker run -ti $(zaw-rad-docker-image-extract-fullname $1) bash"
}

function zaw-rad-docker-image-push() {
    zaw-rad-buffer-action "docker push $(zaw-rad-docker-image-extract-fullname $1)"
}

function zaw-rad-docker-image-pull() {
    zaw-rad-buffer-action "docker pull $(zaw-rad-docker-image-extract-fullname $1)"
}

function zaw-rad-docker-image-inspect() {
    zaw-rad-buffer-action "docker inspect $(zaw-rad-docker-image-extract-fullname $1)"
}

function zaw-rad-docker-image-history() {
    zaw-rad-buffer-action "docker history $(zaw-rad-docker-image-extract-fullname $1)"
}

function zaw-rad-docker-image-rmi() {
    zaw-rad-docker-image-multiselect-action 'docker rmi'
}

function zaw-rad-docker-image-tag() {
    local reply=()
    filter-select -k -e select-action -t "enter new tag" -- "${(@)exec_candidates}"
    [[ $? -eq 0 ]] || return $?


    local repo=$(zaw-rad-docker-image-extract-repo $1)
    local fullname=$(zaw-rad-docker-image-extract-fullname "$1")
    local newtag=${reply[2]}

    zaw-rad-buffer-action "docker tag $fullname $repo:$newtag"
}

function zaw-rad-docker-image-append-name-to-buffer() {
    zaw-rad-buffer-action "$(zaw-rad-docker-image-extract-fullname $1)" accept-search
}

function zaw-rad-docker-image-append-id-to-buffer() {
    zaw-rad-buffer-action "$(echo $1 | awk '{print $3}')" accept-search
}

zaw-register-src -n rad-docker-image zaw-src-rad-docker-image
