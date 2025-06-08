# These are some functions to be shared among rad plugins
# Functions will be prefixed with 'rad-' to avoid any conflicts

# This function must be here.  Do not move it
rad-get-caller-path() {
  local source_file
  for source_file in "${funcsourcetrace[@]}"; do
    [[ "$source_file" != *"rad-get-caller-path"* ]] && echo "${source_file:h}" && return
  done
}

rad-import-local() {
  # Ignore if we're not in zsh, for now.  At some point maybe fully support other shells
  if [[ -n "$ZSH_VERSION" ]]; then
    local filename="$1"
    source "$(rad-get-caller-path)/${filename}"
  fi
}

# Import local modules
rad-import-local rad-colorize.zsh
rad-import-local rad-path-utils.zsh
rad-import-local rad-editor-utils.zsh
rad-import-local rad-zstyle.zsh
rad-import-local rad-kvs.zsh
rad-import-local rad-helpers.zsh

# Make rad-shell bins available to path
RAD_SHELL_ROOT="$(rad-realpath "${0:a:h}/..")"
export RAD_SHELL_ROOT
rad-addpath "${RAD_SHELL_ROOT}/bin"

# Set RAD_ZSH_MANAGER_ROOT (could be either ~/.zgen or ~/.zgenom, or something else in the future)
RAD_ZSH_MANAGER_ROOT="$(rad-realpath "${RAD_SHELL_ROOT}/../..")"
export RAD_ZSH_MANAGER_ROOT

# Ensure ZSH_CACHE_DIR & ZSH_COMPLETIONS_DIR are setup
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
export ZSH_COMPLETIONS_DIR="${ZSH_CACHE_DIR}/completions"
mkdir -p "${ZSH_COMPLETIONS_DIR}"

