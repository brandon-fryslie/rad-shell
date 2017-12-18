# Groovy (sdkman)

# Put this in a function so local_options can reset noclobber
sdkman-init() {
  setopt noclobber local_options
  [[ -f $HOME/.sdkman/bin/sdkman-init.sh ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
}

sdkman-init
