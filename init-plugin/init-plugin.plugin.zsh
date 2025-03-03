# These are some functions to be shared among rad plugins
# Functions will be prefixed with 'rad-' to avoid any conflicts


rad-get-caller-path() {
  local source_file
  for source_file in "${funcsourcetrace[@]}"; do
    [[ "$source_file" != *"rad-get-caller-path"* ]] && echo "${source_file:h}" && return
  done
}

rad-import-local() {
  # Ignore if we're not in zsh
  if [[ -n "$ZSH_VERSION" ]]; then
    local filename="$1"
    source "$(rad-get-caller-path)/${filename}"
  fi
}

rad-get-visual-editor() {
  echo "${VISUAL:-${EDITOR:-vi}}"
}

rad-get-editor() {
  echo "${EDITOR:-vi}"
}

# rad zstyle functions
rad-zstyle-set() {
  local context=$1 style=$2 varname=$3
  zstyle -- ":radsh:${context}:" "${style}" "${varname}"
}

rad-zstyle-get() {
  local context=$1 style=$2 varname=${3:-REPLY}
  zstyle -g "${varname}" ":radsh:${context}:" "${style}"
  echo $REPLY
}

rad-zstyle-test() {
  local context=$1 style=$2
  zstyle -t ":radsh:${context}:" "${style}"
}
# / rad zstyle functions

# colorize zsh text.  allows arbitrary values (foreground, background, bold/underline/etc)
# not fully working with all styles, but works with bold (mostly)
rad-colorize() {
  local fg_code="${1:-39}" bg_code="${2:-49}" deco_code="${3:-0}"; shift 3
  local previous_deco_code="$(rad-zstyle-get "colorize" "deco-code")"

  # If we're in bold, set the flag to true (todo: replace with more generic code to store deco varname)
  [[ $deco_code == "1" ]] && rad-zstyle-set colorize bold-enabled true

  # Set the deco code.  maybe we can use this to determine whether we're in a specific mode?
  rad-zstyle-set colorize deco-code $deco_code

  # check whether we're bolded or not
  rad-zstyle-test colorize bold-enabled && deco_code=1 || deco_code=${deco_code}

  # print the thing
  echo -e "$(rad-color_code $fg_code $bg_code $deco_code)${@//$(rad-color_code 0)/$(rad-color_code $fg_code $bg_code $deco_code)}$(rad-color_code 0)"

  # Unset bold when we're done
  [[ $deco_code == ${previous_deco_code} ]] && rad-zstyle-set colorize bold-enabled false
}

rad-color_code() { echo -e '\033['"${3:-0}"';'"${1:-39}"';'"${2:-49}"'m'; }

# https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
# example of rgb foreground
# rad-rgb() { echo -e "$(rad-colorize "38:5:228" "" "" "$@")"; }
rad-bold()     { echo -e "$(rad-colorize "" "" 1  "$@")"; }
rad-red()      { echo -e "$(rad-colorize 31 "" 1 "$@")"; }
rad-green()    { echo -e "$(rad-colorize 32 "" "" "$@")"; }
rad-yellow()   { echo -e "$(rad-colorize 33 "" "" "$@")"; }
rad-blue()     { echo -e "$(rad-colorize 34 "" 1 "$@")"; }
rad-magenta()  { echo -e "$(rad-colorize 35 "" "" "$@")"; }
rad-cyan()     { echo -e "$(rad-colorize 36 "" "" "$@")"; }
rad-warning()  { echo -e "$(rad-colorize 33 "" 4  "$@")"; }
rad-serious()  { echo -e "$(rad-colorize 33 "" 4  "$@")"; }
rad-critical() { echo -e "$(rad-colorize 31 "" 7  "$@")"; }

# Cross-platform get path
rad-realpath() {
  local f base dir
  set +e

  f=$@
  [ -d "$f" ] && {
    base=""
    dir="$f"
  }
  [ ! -d "$f" ] && {
    base="/$(basename "$f")"
    dir=$(dirname "$f")
  }
  dir="$(cd "${dir}" && /bin/pwd)"
  echo "${dir}${base}"
}

# Add a directory to the path only if it's not already there
rad-addpath() {
  local new_path=$1

  # Check if the new path is provided
  if [[ -z "$new_path" ]]; then
    echo "Usage: rad-addpath <path>"
    return 1
  fi

  # Check if the new path is already in $PATH
  if [[ ":$PATH:" != *":$new_path:"* ]]; then
    export PATH="$new_path:$PATH"
  fi
}

# Import local module
rad-import-local rad-shell-kv-store.zsh

# Make rad-shell bins available to path
export RAD_SHELL_DIR="$(rad-realpath "${0:a:h}/..")"
rad-addpath "${RAD_SHELL_DIR}/bin"

# Ensure ZSH_CACHE_DIR & ZSH_COMPLETIONS_DIR are setup
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
export ZSH_COMPLETIONS_DIR="${ZSH_CACHE_DIR}/completions"
mkdir -p "${ZSH_COMPLETIONS_DIR}"

