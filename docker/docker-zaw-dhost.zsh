bindkey '^[H' zaw-rad-docker-dhost

function zaw-src-rad-docker-dhost() {
    local title="docker hosts"
    : ${(A)candidates::=$(echo "${(v)DHOST_ALIAS_MAP}" | tr ' ' "\n")}
    : ${(A)cand_descriptions::=$(echo "${(k)DHOST_ALIAS_MAP}" | tr ' ' "\n")}
    actions=(\
        zaw-rad-docker-dhost-set-dockerhost \
        # zaw-rad-docker-dhost-clean \
        # zaw-rad-docker-dhost-doctor \
        zaw-rad-append-to-buffer \
    )
    act_descriptions=(\
        "set DOCKER_HOST" \
        # "clean" \
        # "doctor" \
        "append name to buffer" \
    )
    options=(-t "$title" -m)
}

function zaw-rad-docker-dhost-set-dockerhost() {
    zaw-rad-buffer-action "dhost $1"
}

function zaw-rad-docker-dhost-clean() {
    zaw-rad-buffer-action "dhost $1 && docker-clean"
}

function zaw-rad-docker-dhost-doctor() {
    zaw-rad-buffer-action "dhost $1 && ddoctor"
}

zaw-register-src -n rad-docker-dhost zaw-src-rad-docker-dhost
