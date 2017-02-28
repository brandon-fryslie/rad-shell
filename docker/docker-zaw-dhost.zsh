bindkey '^[H' zaw-rad-docker-dhost

function zaw-src-rad-docker-dhost() {
    local title="docker hosts"
    : ${(A)candidates::=$(echo "${(v)DHOST_ALIAS_MAP}" | tr ' ' "\n")}
    : ${(A)cand_descriptions::=$(echo "${(k)DHOST_ALIAS_MAP}" | tr ' ' "\n")}
    actions=(\
        zaw-src-rad-docker-dhost-execute \
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
    zaw-rad-action ${reply[1]}
}

zaw-register-src -n rad-docker-dhost zaw-src-rad-docker-dhost
