bindkey '^[H' zaw-rad-docker-dhost

function zaw-src-rad-docker-dhost() {
    local title="docker hosts"
    : ${(A)candidates::=$(echo "${(v)DHOST_ALIAS_MAP}" | tr ' ' "\n")}
    : ${(A)cand_descriptions::=$(echo "${(k)DHOST_ALIAS_MAP}" | tr ' ' "\n")}
    actions=(\
        zaw-rad-append-to-buffer \
        zaw-rad-append-to-buffer \
    )
    act_descriptions=(\
        "set DOCKER_HOST" \
        "append name to buffer" \
    )
    options=(-t "$title" -m)
}

function zaw-src-rad-docker-dhost-execute() {
    BUFFER="dhost $1"
    zle accept-line
}

function zaw-src-rad-docker-image-rmi() {
    BUFFER="docker rmi $1"
    zle accept-line
}

zaw-register-src -n rad-docker-dhost zaw-src-rad-docker-dhost
