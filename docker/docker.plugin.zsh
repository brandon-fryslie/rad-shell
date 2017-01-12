alias ds="docker status"
alias di="docker images"
alias db="docker build"
alias de="docker exec"
alias dps="docker ps"
alias drm="docker rm"
alias drmi="docker rmi"
alias dc="docker-compose"

# Dhost is a utility for setting your docker host
dhost() {
  if [ -z "$1" ]; then
      echo $DOCKER_HOST
      return
  fi

  local dhost
  local host_string=$1
  local port=${2:-2375}

  # Check to see if host_string is in host map
  if [[ ! -z $DHOST_HOST_MAP[$host_string] ]]; then
    host_string=$DHOST_HOST_MAP[$host_string]
  fi

  # Check to see if there is a custom resolver
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
    if [[ $hist_line =~ 'DOCKER_HOST=tcp://([a-zA-Z]([a-zA-Z0-9]|\-|\.)+)' ]]; then
      _dhost_hist_completions+=$match[1]
    fi
  done <<< "$hist_list"

  # Complete from custom host map
  _dhost_host_map_completions=()
  if [[ ! -z $DHOST_HOST_MAP ]]; then
    for host in "${(@kv)DHOST_HOST_MAP}"; do
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
