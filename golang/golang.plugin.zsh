# Golang plugin

rad-init-golang() {
  local BREW_GOPATH="$HOME/golang"

  if [[ -d $BREW_GOPATH ]]; then
    export GOPATH=$BREW_GOPATH
    export PATH="$GOPATH/bin:$PATH"
  fi
}

rad-init-golang
