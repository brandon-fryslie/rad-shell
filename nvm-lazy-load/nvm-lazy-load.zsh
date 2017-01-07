# This plugin allows lazy-loading nvm when any global node command is called
#
# Adds stubs for each global node command to the environment, then loads nvm and
# replaces them when the stub is called
#
# Some smarts are in place to source the nvm script a minimum number of times

declare -a NODE_GLOBALS
NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)

NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")

load_nvm () {
    export NVM_DIR=~/.nvm
    zstyle ':nvm-lazy-load' nvm-loaded 'yes'
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

setup_node_aliases() {
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

setup_node_aliases
