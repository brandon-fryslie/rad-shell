# These are some functions to be shared among rad plugins
# Functions will be prefixed with 'rad-' to avoid any conflicts

rad-get-visual-editor() {
  echo "${VISUAL:-${EDITOR:-vi}}"
}

rad-get-editor() {
  echo "${EDITOR:-vi}"
}

rad-colorize() { CODE=$1; shift; echo -e '\033[0;'$CODE'm'$*'\033[0m'; }
rad-bold() { echo -e "$(rad-colorize 1 "$@")"; }
rad-red() { echo -e "$(rad-colorize '1;31' "$@")"; }
rad-green() { echo -e "$(rad-colorize 32 "$@")"; }
rad-yellow() { echo -e "$(rad-colorize 33 "$@")"; }

rad-realpath() {
  local f base dir
  f=$@
  if [ -d "$f" ]; then
    base=""
    dir="$f"
  else
    base="/$(basename "$f")"
    dir=$(dirname "$f")
  fi
  dir=$(cd "$dir" && /bin/pwd)
  echo "$dir$base"
}

export RAD_SHELL_DIR="$(rad-realpath "${0:a:h}/..")"
export PATH="$PATH:$RAD_SHELL_DIR"

