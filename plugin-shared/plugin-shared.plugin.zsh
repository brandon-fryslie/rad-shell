# These are some functions to be shared among rad plugins
# Functions will be prefixed with 'rad-' to avoid any conflicts

rad-get-visual-editor() {
  echo "${VISUAL:-${EDITOR:-vi}}"
}

rad-get-editor() {
  echo "${EDITOR:-vi}"
}
