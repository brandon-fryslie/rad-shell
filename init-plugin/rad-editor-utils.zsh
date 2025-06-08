rad-get-visual-editor() {
  echo "${VISUAL:-${EDITOR:-vi}}"
}

rad-get-editor() {
  echo "${EDITOR:-vi}"
}
