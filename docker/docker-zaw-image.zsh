bindkey '^[<' zaw-rad-docker-image

function zaw-src-rad-docker-image() {
    title="$(docker images | head -n 1)"
    desc="$(docker images | tail +2)"
    image_id="$(echo $desc | awk '{print $3}')"
    : ${(A)candidates::=${(f)image_id}}
    : ${(A)cand_descriptions::=${(f)desc}}
    actions=(\
        zaw-src-rad-docker-append-to-buffer \
        zaw-src-rad-docker-image-history \
        zaw-src-rad-docker-image-rmi \
    )
    act_descriptions=(\
        "append id to buffer" \
        "history" \
        "rmi" \
    )
    options=(-t "$title" -m)
}

function zaw-src-rad-docker-image-history() {
    BUFFER="docker history $1"
    zle accept-line
}

function zaw-src-rad-docker-image-rmi() {
    BUFFER="docker rmi $1"
    zle accept-line
}

zaw-register-src -n rad-docker-image zaw-src-rad-docker-image
