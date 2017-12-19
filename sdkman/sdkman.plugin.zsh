# Groovy (sdkman)

# Put this in a function so local_options can reset noclobber
sdkman-init() {
  noclobber_setting=$(set -o | grep noclobber | awk '{print $2}')
  set +o noclobber
  [[ -f $HOME/.sdkman/bin/sdkman-init.sh ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

  if [[ $noclobber_setting == 'on' ]]; then
    set -o noclobber
  fi
}

sdkman-init
