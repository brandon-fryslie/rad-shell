bindkey '^[<' zaw-rad-docker-image

function zaw-src-rad-docker-image() {
    title="$(docker images | head -n 1)"
    desc="$(docker images | tail +2)"
    image_id="$(echo $desc | awk '{print $3}')"
    : ${(A)candidates::=${(f)image_id}}
    : ${(A)cand_descriptions::=${(f)desc}}
    actions=(\
        zaw-src-rad-docker-image-inspect \
        zaw-src-rad-docker-image-history \
        zaw-src-rad-docker-image-rmi \
        zaw-rad-append-to-buffer \
    )
    act_descriptions=(\
        "inspect" \
        "history" \
        "rmi" \
        "append id to buffer" \
    )
    options=(-t "$title" -m)
}

function zaw-src-rad-docker-image-inspect() {
    BUFFER="docker inspect $1"
    zaw-rad-action ${reply[1]}
}

function zaw-src-rad-docker-image-history() {
    BUFFER="docker history $1"
    zaw-rad-action ${reply[1]}
}

function zaw-src-rad-docker-image-rmi() {
    BUFFER="docker rmi $1"
    zaw-rad-action ${reply[1]}
}

zaw-register-src -n rad-docker-image zaw-src-rad-docker-image
