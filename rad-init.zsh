### rad-shell init file
### handles setting up zgenom (or zgen) to make life simpler

# Set up a global var to store init errors
typeset -g _rad_init_err

# define our rad-debug command
rad-debug() {
  [[ -z $RAD_DEBUG ]] && return

  local ts msg
  ts="$(date '+%H:%M:%S')"
  msg="${*}"
  echo -e "\e[1;36m[$ts] RAD-DEBUG:\e[0m \e[1;33m${msg}\e[0m"
}

_rad_init_check_error() {
  if [[ -n "${_rad_init_error}" ]]; then
    echo "ERROR: rad-shell: Encountered init error: ${_rad_init_error}"
    return 1
  fi
  return 0
}

# Handle zgen to zgenom migration
# the easiest solution is to simply move the ~/.zgen directory
# it's unlikely anyone has made any modifications there, and if they have,
# they are probably smart enough to figure out how to move them to the new location
_rad_handle_zgenom_migration() {
  _rad_init_check_error

  local zgen_dir=$HOME/.zgen
  local zgen_bak_dir="${zgen_dir}.bak"
  if [[ -e "${zgen_dir}" ]]; then
    if [[ -e "${zgen_bak_dir}" ]]; then
      echo "ERROR: rad-shell: Both ${zgen_dir} and ${zgen_bak_dir} already exist.  Cannot proceed with migration to zgenom."
      echo "ERROR: rad-shell: Please remove one or both of them.  These directories contain the downloaded zsh plugins."
      echo "ERROR: rad-shell: If you have not modified any plugins or you don't want to save modifications, you can safely remove them both and they'll be "
      echo "ERROR: rad-shell: remove them both and they'll be downloaded again automatically."
      echo "ERROR: rad-shell: ZGEN has not been updated in 7 years and its usage with rad-shell is no longer supported.  ZGENOM is a drop in replacement."
      _rad_init_err="ERROR: Cannot migrate to Zgenom"
    fi
    mv "${zgen_dir}" "${zgen_bak_dir}"
    echo "Moved ${zgen_dir} -> ${zgen_bak_dir}!  Proceeding with zgenom migration"
  fi
}

# Very basic initial configuration that must happen before modules are loaded
_rad_pre_init() {
  # If we encountered an error previous, return early
  _rad_init_check_error || return

  # Allow users to skip pre-init
  [[ -n "${RAD_SKIP_PRE_INIT}" ]] && return

  # Initialize the completion engine
  ZGEN_AUTOLOAD_COMPINIT=1

  # Configure $ZGEN_RESET_ON_CHANGE

  # Any changes to this path require recompiling the init file
  local rad_plugins_file_path="${HOME}/.rad-plugins"

  # If it's not an array, and it contains a value, store the value
  # Then declare the variable as a global array and re-add the temp value if there was one
  if [[ "${(t)ZGEN_RESET_ON_CHANGE}" != "array" ]]; then
    if [[ -n $ZGEN_RESET_ON_CHANGE ]]; then
      local tmp_reset_on_change="${ZGEN_RESET_ON_CHANGE}"
      unset ZGEN_RESET_ON_CHANGE
    fi
    typeset -ga ZGEN_RESET_ON_CHANGE
    [[ -n "${tmp_reset_on_change}" ]] && ZGEN_RESET_ON_CHANGE+=("${tmp_reset_on_change}")
  fi

  # Finally, add the .rad-plugins file path
  ZGEN_RESET_ON_CHANGE+=($rad_plugins_file_path)

  # Plugins can register an init hook that will be called after all plugins are loaded
  # This allows us to avoid module load order dependencies by delaying initialization until dependencies have all been loaded
  typeset -ga rad_plugin_init_hooks

  zstyle ':prezto:module:terminal' auto-title 'yes'
  zstyle ':prezto:module:terminal:window-title' format '%n@%m'
  zstyle ':prezto:module:terminal:tab-title' format '%s'

  # Remove alias 'rm' -> 'rm -i' if it exists
  # If you want it, add it back in a plugin or your .zshrc
  alias rm &>/dev/null && unalias rm

  # Use bash-style word delimiters
  autoload -U select-word-style
  select-word-style bash
}

_rad_zg_init() {
  _rad_init_check_error || return

  local zgenom_file="${HOME}/.zgenom/zgenom.zsh"
  local zgen_file="${HOME}/.zgen/zgen.zsh"

  if [[ -f "${zgenom_file}" ]]; then
    rad-debug "Loading zgenom"
    source "${HOME}/.zgenom/zgenom.zsh"
    # Add compatibility shim for backward compatibility with zgen
    function zgen() zgenom $@
  elif [[ -f "${zgen_file}" ]]; then
    # we should never get here, as we cleaned up the .zgen directory previously
    rad-debug "Loading zgen"
    . "${HOME}/.zgen/zgen.zsh"
  else
    _rad_init_err="ERROR: rad-shell: zgenom is not installed properly (file ${zgenom_file} does not exist).  Please rerun installer."
  fi

  [[ -n $_rad_init_err ]] && { echo "${_rad_init_err}" }
}

_rad_handle_zgenom_migration
_rad_pre_init
_rad_zg_init

# if the init scipt doesn't exist
if [[ -z $_rad_init_error ]] && ! zgenom saved; then
  # TODO: allow executing arbitary code here
  # We will implement this when we have decided on a better path than
  # dumping everything in $HOME
  # source /path/to/some/raw/zsh/config

  # Loads prezto base and default plugins:
  # environment terminal editor history directory spectrum utility completion prompt
  zgenom prezto

  # Extra prezto plugins
  zgenom prezto fasd
  zgenom prezto git
  zgenom prezto history-substring-search

  # Initializes some functionality baked into rad-shell
  zgenom load brandon-fryslie/rad-shell init-plugin

  # Initialize oh-my-zsh libraries required to use oh-my-zsh themes
  zgenom load ohmyzsh/ohmyzsh lib/git.zsh
  zgenom load ohmyzsh/ohmyzsh lib/prompt_info_functions.zsh
  zgenom load ohmyzsh/ohmyzsh lib/theme-and-appearance.zsh

  # Here is where we load plugins from $HOME/.rad-plugins
  while read -r line; do
    if [[ ! $line =~ '^#' ]] && [[ ! $line == '' ]]; then
      echo "rad-shell: Loading plugin: $line"
      eval "zgenom load $line"
    fi
  done < "$HOME/.rad-plugins"


  local zgenom_save_args=""
  [[ "${ZGENOM_ENABLE_COMPILE:-1}" != 1 ]] && zgenom_save_args+="--no-compile"
  time zgenom save "${zgenom_save_args}"
fi

# Execute the init hooks.  This gives plugins a way to execute code after all other plugins are loaded
for init_hook in "${rad_plugin_init_hooks[@]}"; do
  # Pass the script path to the init hook
  ${init_hook%%:*} ${init_hook##*:}
done

# Cleanup
unset -f _rad_init_check_error _rad_handle_zgenom_migration _rad_pre_init _rad_zg_init
unset _rad_init_err

# TODO: should we unset rad_plugin_init_hooks?  Don't see a particular reason to at the moment
# unset rad_plugin_init_hooks
