# Golang

rad-init-golang() {
  BREW_GOPATH="$HOME/golang"

  if [[ ! -d $GOPATH ]]; then
    if [[ (( $+commands[jq] )) ]]; then
      # If no gopath defined and brew is installed, use brew to install golang
      brew install golang
    fi

    export BREW_GOPATH="$HOME/golang"
    export PATH="$GOPATH/bin:$PATH"
  fi
}

