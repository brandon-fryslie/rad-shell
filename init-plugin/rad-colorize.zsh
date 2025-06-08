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
