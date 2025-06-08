# Initialize the completion engine
ZGEN_AUTOLOAD_COMPINIT=1

# Automatically regenerate zgen configuration when ~/.rad-plugins changes
ZGEN_RESET_ON_CHANGE=$HOME/.rad-plugins

# Plugins can register an init hook that will be called after all plugins are loaded
# This allows us to avoid module load order dependencies by delaying initialization until dependencies have all been loaded
declare -a rad_plugin_init_hooks

zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:window-title' format '%n@%m'
zstyle ':prezto:module:terminal:tab-title' format '%s'

# Remove alias 'rm' -> 'rm -i' if it exists
alias rm &>/dev/null && unalias rm

# Use bash-style word delimiters
autoload -U select-word-style
select-word-style bash

rad-debug() {
  [[ -n $RAD_DEBUG && $RAD_DEBUG != 0 ]] && print -P "RAD DEBUG: %F{cyan}$1%f"
}

rad-array-difference() {
  # Arguments:
  #   1. Name of the result array to assign to (by name).
  #   2. Name of array A (source array to compare).
  #   3. Name of array B (array containing items to exclude).

  # Local variables.
  local result_name=$1
  local array_a_name=$2
  local array_b_name=$3

  # Declare arrays for the actual data.
  local -a array_a
  local -a array_b
  local -a result=()

  # Declare associative array for fast lookup.
  local -A bmap
  local item

  # Read arrays indirectly from provided names.
  array_a=("${${(P)array_a_name}[@]}")
  array_b=("${${(P)array_b_name}[@]}")

  # Build a lookup map of items in array B.
  for item in "${array_b[@]}"; do
    bmap[$item]=1
  done

  # Iterate over array A.
  for item in "${array_a[@]}"; do
    # If item is NOT found in B's map, add to result.
    if [[ -z ${bmap[$item]} ]]; then
      result+=("$item")
    fi
  done

  # Assign the result array to the provided name using indirect assignment.
  ${(P)result_name::=${(q@)result}}

  # Optional debug output.
  # Uncomment for debugging:
#   print -l -- "array_a: (len ${#array_a}) ${array_a[*]}"
#   print -l -- "array_b: (len ${#array_b}) ${array_b[*]}"
#   print -l -- "result: ${result[@]}"
}

rad-force-fn-reload() {
  local func src
  local -a exclude_dirs exclude_fns

  # Define exclusions
  include_dirs=("${RAD_ZSH_MANAGER_ROOT}")
  exclude_dirs=("${HOME}/.rad-shell/rad-init.zsh" /usr/share/zsh)
  exclude_fns=(rad-debug rad-force-fn-reload)
  exclude_plugins=(zsh-syntax-highlighting-master prezto-master/modules/editor/init.zsh)

  rad-debug 'rad force fn reload: unsetting functions loaded by rad-shell'

  for func in ${(k)functions_source}; do
    src="${functions_source[$func]}"

    [[ -z "${src}" ]] && {
#      rad-debug "Skipping '${func}' (src: '${src}') [empty src]"
      continue
    }

    # Skip if source path does NOT start with any included directory
    for dir in "${include_dirs[@]}"; do
#      rad-debug "Checking include dir '${dir}'"
      [[ $src != $dir* ]] && { rad-debug "Skipping '${func}' (src: '${src}') [not included]"; continue 2; }
    done

    [[ ${exclude_fns[(Ie)$func]} -ne 0 ]] && { rad-debug "Skipping '${func}' [excluded fn]"; continue; }

    # Skip if source path starts with any excluded directory
    for dir in "${exclude_dirs[@]}"; do
      [[ $src == $dir* ]] && { rad-debug "Skipping '${func}' (src: '${src}') [excluded dir]"; continue 2; }
    done

    # Skip excluded plugins
    for plugin in "${exclude_plugins[@]}"; do
      [[ $src == "${RAD_ZSH_MANAGER_ROOT}"*"${plugin}"* ]] && { rad-debug "Skipping '${func}' (src: '${src}') [excluded plugin]"; continue 2; }
    done

    # Unset the function
    rad-debug "Unsetting function: $func (from $src)"
    unset -f -- "${func}"
#    RAD_UNLOADED_FUNCS+=("${func}")
  done
}
#RAD_DEBUG=1

rad-zsh-version-at-least() {
  [[ $1 =~ ^[0-9]+\.[0-9]+$ ]] || { print -u2 "Error: Use x.y format"; return 1; }

  local req_major=${1%%.*} req_minor=${1##*.}
  local cur_major=${ZSH_VERSION%%.*} cur_minor=${ZSH_VERSION#*.}; cur_minor=${cur_minor%%[^0-9]*}

  (( cur_major > req_major || (cur_major == req_major && cur_minor >= req_minor) ))
}


## Reload all functions (note: this requires zsh 5.4 or newer)
#declare -ga RAD_UNLOAD_FUNCS RAD_LOAD_FUNCS RAD_PRE_UNLOAD_FUNCS RAD_POST_UNLOAD_FUNCS RAD_PRE_LOAD_FUNCS RAD_POST_LOAD_FUNCS
#if rad-zsh-version-at-least 5.4; then
#  # shellcheck disable=SC2154
#  RAD_PRE_UNLOAD_FUNCS=("${(@ok)functions}")
#  rad-force-fn-reload
#  RAD_POST_UNLOAD_FUNCS=("${(@ok)functions}")
#
#  # set RAD_UNLOAD_FUNCS to all fns that are in POST but not in PRE
#  rad-array-difference RAD_UNLOAD_FUNCS RAD_POST_UNLOAD_FUNCS RAD_PRE_UNLOAD_FUNCS
#
#  rad-debug "Unloaded ${#RAD_UNLOAD_FUNCS} funcs"
#  echo "Total loaded functions: pre unload: ${#RAD_PRE_UNLOAD_FUNCS}, post unload: ${#RAD_PRE_UNLOAD_FUNCS}"
#else
#  rad-debug "Skipping function reloading.  Requires zsh version 5.4 or newer"
#fi


#declare -ga RAD_LOAD_FUNC_DELTA RAD_LOAD_FUNC_DELTA_PREVIOUS
#
#RAD_PRE_LOAD_FUNCS=("${(@ok)functions}")
#
# This is where the magic happens!
source "${HOME}/.zgen/zgen.zsh"
#
#RAD_POST_LOAD_FUNCS=("${(@ok)functions}")
#
#rad-array-difference RAD_LOAD_FUNC_DELTA RAD_POST_LOAD_FUNCS RAD_PRE_LOAD_FUNCS
#
#echo "Function delta: ${#RAD_LOAD_FUNC_DELTA}"
##print -l "${RAD_LOAD_FUNC_DELTA[@]}"
#echo "Total loaded functions: pre zsh load: ${#RAD_PRE_LOAD_FUNCS}, post zsh load: ${#RAD_POST_LOAD_FUNCS}"
#
#if [[ ${#RAD_LOAD_FUNC_DELTA_PREVIOUS[@]} -gt 0 ]]; then
#  echo "Previous function delta total: ${#RAD_LOAD_FUNC_DELTA_PREVIOUS}"
#  echo "Current function delta total: ${#RAD_LOAD_FUNC_DELTA}"
#  rad-array-difference RAD_LOAD_FUNC_DELTA_DELTA RAD_LOAD_FUNC_DELTA_PREVIOUS RAD_LOAD_FUNC_DELTA
#  echo "DELTA DELTA: ${#RAD_LOAD_FUNC_DELTA_DELTA}"
#fi
#
#RAD_LOAD_FUNC_DELTA_PREVIOUS=("${RAD_LOAD_FUNC_DELTA[@]}")
#
#unset -- RAD_PRE_UNLOAD_FUNCS RAD_POST_UNLOAD_FUNCS RAD_PRE_LOAD_FUNCS RAD_POST_LOAD_FUNCS

# if the init scipt doesn't exist
if ! zgen saved; then

  # Loads prezto base and default plugins:
  # environment terminal editor history directory spectrum utility completion prompt
  zgen prezto

  # Extra prezto plugins
  zgen prezto fasd
  zgen prezto git
  zgen prezto history-substring-search

  # Initializes some functionality baked into rad-shell
  zgen load brandon-fryslie/rad-shell init-plugin

  # Initialize oh-my-zsh libraries required to use oh-my-zsh themes
  zgen load ohmyzsh/ohmyzsh lib/git.zsh
  zgen load ohmyzsh/ohmyzsh lib/prompt_info_functions.zsh
  zgen load ohmyzsh/ohmyzsh lib/theme-and-appearance.zsh

  # Here is where we load plugins from $HOME/.rad-plugins
  while read -r line; do
    if [[ ! $line =~ '^#' ]] && [[ ! $line == '' ]]; then
      echo "Loading plugin: $line"
      eval "zgen load $line"
    fi
  done < "$HOME/.rad-plugins"

  zgen save
fi

for init_hook in "${rad_plugin_init_hooks[@]}"; do
  # Pass the script path to the init hook
  ${init_hook%%:*} ${init_hook##*:}
done
