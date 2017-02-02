alias ds="docker status"
alias di="docker images"
alias db="docker build"
alias de="docker exec"
alias dps="docker ps"
alias drm="docker rm"
alias drmi="docker rmi"
alias dc="docker-compose"

# Docker Helper commands.  Mostly useful for local development

# Show docker logs for a container matching a search string, or the most recently run
# container if no search string is provided
dlogs() {
  if [[ -z $1 ]]; then
    echo "Showing logs of first container..."
    local container_info="$(docker ps -a --format '{{.ID}} {{.Image}} {{.Names}}' | head -n 1)"
  else
    local search_string=$1
    local container_info="$(docker ps -a --format '{{.ID}} {{.Image}} {{.Names}}' | grep $search_string | head -n 1)"
  fi
  container_image=$(echo $container_info | awk '{print $2}')
  container_name=$(echo $container_info | awk '{print $3}')
  echo "Showing logs of container $container_name running image $container_image..."
  docker logs -f $container_name
}

# Print SHAs of all docker containers
dall() {
  docker ps -aq
}

# Print SHA of most recently run docker container, or docker container matching
# search string
dfirst() {
  if [[ -z $1 ]]; then
    echo $(docker ps -aq | head -n 1) || echo 'NO_CONTAINER_FOUND'
  else
    echo $(docker ps --format '{{.ID}} {{.Image}} {{.Names}}' -a | grep $1 | head -n 1 | awk '{print $1}') || echo 'NO_CONTAINER_FOUND'
  fi
}

dkill() {
  docker rm -fv `dfirst $1`
}

# Exec into the container matching 'search string'
dexec() {
  docker exec -ti `dfirst $1` ${2:-bash}
}

# Dhost is a utility for setting your docker host

typeset -Ax DHOST_ALIAS_MAP
DHOST_ALIAS_MAP=()

dhost-alias() {
  DHOST_ALIAS_MAP[$1]=$2
}

dhost() {
  if [ -z "$1" ]; then
      echo $DOCKER_HOST
      return
  fi

  local dhost
  local host_string=$1
  local port=${2:-2375}

  if [[ $host_string == local ]] || [[ $host_string == unset ]]; then
    unset DOCKER_HOST
    echo "unsetting DOCKER_HOST"
    return 0
  fi

  # Check host aliases
  if [[ $host_string =~ '^[a-zA-Z0-9]+$' ]] && [[ ! -z $DHOST_ALIAS_MAP[$host_string] ]]; then
    host_string=$DHOST_ALIAS_MAP[$host_string]
  fi

  # Use custom resolver if specified
  if type dhost_custom_resolver &>/dev/null; then
    res=$(dhost_custom_resolver $host_string)
    [[ ! -z $res ]] && host_string=$res
  fi

  dhost="tcp://$host_string"

  # Append port if needed
  if [[ ! $dhost =~ ':[0-9]+$' ]]; then
    dhost="$dhost:$port"
  fi

  # Add DOCKER_HOST="docker-hostname" to history
  print -s "export DOCKER_HOST=$dhost"

  export DOCKER_HOST=$dhost
  echo "DOCKER_HOST=$dhost"
}

# Completions for Dhost command
_dhost_completion() {
  local hist_list host include_pattern=${DHOST_INCLUDE_PATTERN}

  # Complete from SSH Hosts
  _dhost_ssh_host_list=$(echo ${${${${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ } | tr ' ' '\n' | sort | uniq)

  if [[ ! -z $include_pattern ]]; then
    _dhost_ssh_host_list=$(echo $_dhost_ssh_host_list | grep $include_pattern)
  fi

  # Complete from history
  _dhost_hist_completions=()
  hist_list=$(history 1 | grep "DOCKER_HOST=tcp")

  while read -r hist_line; do
    if [[ $hist_line =~ 'DOCKER_HOST=tcp://([a-zA-Z0-9]([a-zA-Z0-9]|\-|\.)+)' ]]; then
      _dhost_hist_completions+=$match[1]
    fi
  done <<< "$hist_list"

  # Complete from custom host map
  _dhost_host_map_completions=()
  if [[ ! -z $DHOST_ALIAS_MAP ]]; then
    for host in "${(@kv)DHOST_ALIAS_MAP}"; do
      _dhost_host_map_completions+=$host
    done
  fi

  reply=(
    ${=_dhost_ssh_host_list}
    ${=_dhost_hist_completions}
    ${=_dhost_host_map_completions}
  )
}

compctl -K _dhost_completion dhost
# /Dhost

# Enable Docker Prompt
export ENABLE_DOCKER_PROMPT=true
