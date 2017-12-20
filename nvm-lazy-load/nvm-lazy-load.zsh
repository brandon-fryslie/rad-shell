# This plugin allows lazy-loading nvm when any global node command is called
#
# Adds stubs for each global node command to the environment, then loads nvm and
# replaces them when the stub is called
#
# Some smarts are in place to source the nvm script a minimum number of times
#
# Credit goes to user 'sscotth' on reddit
# https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/d5ib9fs/

load_nvm () {
  export NVM_DIR=~/.nvm
  zstyle ':nvm-lazy-load' nvm-loaded 'yes'
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

declare -a NODE_GLOBALS
setup_node_aliases() {
  # Do not create stubs for node globals if no versions of node are installed
  if [[ -d ~/.nvm/versions/node ]]; then
    NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
    NODE_GLOBALS+=("node")
  fi

  NODE_GLOBALS+=("nvm")

  local script
  for cmd in "${NODE_GLOBALS[@]}"; do
      script=$(cat <<-EOSCRIPT
          ${cmd}() {
              unset -f ${NODE_GLOBALS}
              zstyle -t ':nvm-lazy-load' nvm-loaded 'yes' || load_nvm
              ${cmd} \$@
          }
EOSCRIPT
  )
      eval "$script"
  done
}

# Do not setup aliases if nvm is not installed
if [[ -d ~/.nvm ]]; then
  setup_node_aliases
fi
