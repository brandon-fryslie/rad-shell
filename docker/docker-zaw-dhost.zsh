bindkey '^[H' zaw-rad-docker-dhost

function zaw-src-rad-docker-dhost() {
    local title="docker hosts"
    : ${(A)candidates::=$(echo "${(v)DHOST_ALIAS_MAP}" | tr ' ' "\n")}
    : ${(A)cand_descriptions::=$(echo "${(k)DHOST_ALIAS_MAP}" | tr ' ' "\n")}

    actions=(zaw-rad-docker-dhost-set-dockerhost)
    command -v 'docker-clean' &> /dev/null && actions+="zaw-rad-docker-dhost-clean"
    command -v ddoctor &> /dev/null && actions+="zaw-rad-docker-dhost-doctor"
    actions+=(zaw-rad-append-to-buffer)

    act_descriptions=("set DOCKER_HOST")
    command -v 'docker-clean' &> /dev/null && act_descriptions+="clean"
    command -v ddoctor &> /dev/null && act_descriptions+="doctor"
    act_descriptions+="append name to buffer"

    options=(-t "$title" -m -k)
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
