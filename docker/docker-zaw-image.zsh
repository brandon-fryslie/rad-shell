bindkey '^[<' zaw-rad-docker-image

function zaw-src-rad-docker-image() {
    title="$(docker images | head -n 1)"
    desc="$(docker images | tail +2)"
    : ${(A)candidates::=${(f)desc}}
    actions=(\
        zaw-rad-docker-image-run \
        zaw-rad-docker-image-inspect \
        zaw-rad-docker-image-history \
        zaw-rad-docker-image-rmi \
        zaw-rad-docker-image-append-name-to-buffer \
        zaw-rad-docker-image-append-id-to-buffer \
    )
    act_descriptions=(\
        "run" \
        "inspect" \
        "history" \
        "rmi" \
        "append name to buffer" \
        "append id to buffer" \
    )
    options=(-t "$title" -m)
}

function zaw-rad-docker-image-run() {
    zaw-rad-buffer-action "docker run -ti $(echo $1 | awk '{print $1}')"
}

function zaw-rad-docker-image-inspect() {
    zaw-rad-buffer-action "docker inspect $(echo $1 | awk '{print $1}')"
}

function zaw-rad-docker-image-history() {
    zaw-rad-buffer-action "docker history $(echo $1 | awk '{print $1}')"
}

function zaw-rad-docker-image-rmi() {
    zaw-rad-buffer-action "docker rmi $(echo $1 | awk '{print $1}')"
}

function zaw-rad-docker-image-append-name-to-buffer() {
    zaw-rad-buffer-action "$(echo $1 | awk '{print $1}')" accept-search
}

function zaw-rad-docker-image-append-id-to-buffer() {
    zaw-rad-buffer-action "$(echo $1 | awk '{print $2}')" accept-search
}

zaw-register-src -n rad-docker-image zaw-src-rad-docker-image
