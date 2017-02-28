bindkey '^[>' zaw-rad-docker-container

function zaw-src-rad-docker-container() {
    local format_string="table {{ .Names }}\\t{{ .Image }}\\t{{ .Status }}\\t{{ .Ports }}\\t{{ .Size }}"
    local title="$(docker ps --format $format_string | head -n 1)"
    local desc="$(docker ps -a --format $format_string | tail +2)"
    local container_id="$(echo $desc | awk '{print $1}')"
    : ${(A)candidates::=${(f)container_id}}
    : ${(A)cand_descriptions::=${(f)desc}}
    actions=(\
        zaw-src-rad-docker-append-to-buffer \
        zaw-src-docker-container-logs \
        zaw-src-docker-container-exec \
        zaw-src-docker-container-inspect \
        zaw-src-docker-container-rm \
    )
    act_descriptions=(\
        "append name to buffer" \
        "logs" \
        "exec" \
        "inspect" \
        "rm -fv" \
    )
    options=(-t "$title" -m)
}

function zaw-src-docker-container-logs() {
    BUFFER="docker logs -f $1"
    zle accept-line
}

function zaw-src-docker-container-exec() {
    local exec_candidates=(bash env "ps ax")
    local reply=()
    filter-select -e select-action -t "select command for exec" -- "${(@)exec_candidates}"
    [[ $? -eq 0 ]] || return $?

    action=${reply[1]}
    exec_command=${reply[2]}

    BUFFER="docker exec -ti $1 $exec_command"
    zle $action
    zle end-of-line
}

function zaw-src-docker-container-inspect() {
    # use jq if we have it
    local jq=''
    [[ (( $+commands[jq] )) ]] && jq="| jq"

    BUFFER="docker inspect $1 $jq"
    zle accept-line
}

function zaw-src-docker-container-rm() {
    BUFFER="docker rm -fv $1"
    zle accept-line
}

zaw-register-src -n rad-docker-container zaw-src-rad-docker-container