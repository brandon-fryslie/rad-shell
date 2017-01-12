alias ds="docker status"
alias di="docker images"
alias db="docker build"
alias de="docker exec"
alias dps="docker ps"
alias drm="docker rm"
alias drmi="docker rmi"
alias dc="docker-compose"

# DHost is a utility for setting your docker host
dhost() {
  local DHOST=DOCKER_HOST=tcp://$1:${2:2375}

  export $DHOST
}
