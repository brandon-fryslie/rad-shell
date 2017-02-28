source "${0:a:h}/docker-zaw-container.zsh"
source "${0:a:h}/docker-zaw-image.zsh"
source "${0:a:h}/docker-zaw-dhost.zsh"

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
  local container_info=$(dfirst "$@")
  container_info=$(echo $container_info | tr '\n' ' ')
  [[ $container_info =~ "^[[:space:]]+$" ]] && { echo "Error: no container found"; return 1}

  container_image=$(echo $container_info | awk '{print $2}')
  container_name=$(echo $container_info | awk '{print $3}')
  echo "Showing logs of container $container_name running image $container_image..."
  docker logs -f $container_name
}

# Print SHAs of all docker containers
dall() {
  docker ps -aq
}

# Print info of most recently run docker container matching all search strings
# Example: dfirst nginx test user1
#
# Add '-a' to search exited containers as well
# Example: dfirst -a my_exited_container other_search_string
#
# Add '-q' to only print the container id
dfirst() {
  dsearch "$@" | head -n 1
}

# Search running containers
# Prints info for all containers matching the search string
# Example: dsearch nginx test user1
#
# Add '-a' to search exited containers as well
# Example: dsearch -a my_exited_container other_search_string
#
# Add '-q' to only print the container ids
dsearch() {
  # Parse options
  while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
      -a) local ALL_IMAGES=-a; shift;;
      -q) local QUIET=true; shift;;
      -aq|-qa) local QUIET=true; local ALL_IMAGES=-a; shift;;
      -d) local DEBUG=true; shift;;
      -*) echo "Unknown option: $1"; return 1;;
      *)
        # Handle search strings here
        if [[ -z $search_string ]]; then
          local search_string="grep $1"; shift
        else
          search_string="$search_string | grep $1"; shift
        fi
      ;;
    esac
  done

  # General command
  local cmd="docker ps $ALL_IMAGES --format '{{.ID}} {{.Image}} {{.Names}} {{.Ports}}'"

  # If we have a search string, append it
  if [[ ! -z $search_string ]]; then
    cmd="$cmd | $search_string"
  fi

  # If quiet mode is on, only print container IDs
  [[ $QUIET == true ]] && cmd="$cmd | awk '{print \$1}'"

  if [[ $DEBUG == true ]]; then
    echo "DEBUG MODE ON"
    echo "ALL_IMAGES: $ALL_IMAGES"
    echo "QUIET: $QUIET"
    echo "search string: $search_string"
    echo "running command: $cmd"
  fi

  eval "$cmd"
}

dkill() {
  docker rm -fv `dfirst -q "$@"`
}

# Exec into the container matching the search strings
# By default, it execs 'bash'
# Use the -c option to change this, e.g. 'dexec service_name -c env'
# Usage: 'dexec search_string_1 search_string_2 search_string_3'
dexec() {
  # Parse options
  local search_strings=()
  local command="bash"
  while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
      -c|--command) command="$2"; shift; shift;;
      -*) echo "Unknown option: $1"; return 1;;
      *) search_strings+=("$1"); shift;;
    esac
  done

  docker exec -ti `dfirst -q $search_strings` $command
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
