#!/usr/bin/env zsh

# Script to manage rad-shell

set -e

colorize() { CODE=$1; shift; echo -e '\033[0;'"${CODE}m$*"'\033[0m'; }
bold() { echo -e "$(colorize 1 "$@")"; }
red() { echo -e "$(colorize '1;31' "$@")"; }
green() { echo -e "$(colorize 32 "$@")"; }
yellow() { echo -e "$(colorize 33 "$@")"; }

script_dir="$( cd "$( dirname "${0:a:h}" )" && pwd )"

: ${RAD_PLUGINS_FILE_PATH:="${HOME}/.rad-plugins"}

# Command functions

# TODO
plugin-cmd() {
  local command=$1
  red "command: rad.sh plugin $1 not implemented"
}

version-cmd() {
  cat $script_dir/VERSION
}

byebye-cmd() {
  local zshrc_bak="$HOME/.zshrc.$$.bak"
  yellow "Removing all rad-shell files and backing up ~/.zshrc to $zshrc_bak"
  mv -f ~/.zshrc $zshrc_bak
  rm -rf ~/.zgen
  rm -rf ~/.rad-shell
  rm -rf "${RAD_PLUGINS_FILE_PATH}"
  green "Byebye!"
}

# Validate arguments
usage() {
  yellow "usage: rad.sh [command] [args]"
  yellow "commands:"
  yellow "\tversion: prints the version"
  yellow "\tplugin: add/rm/list plugins"
}

[[ $# == 0 ]] && { usage; exit 1; }

# Parse arguments
case $1 in
  implode|plugin|version) ${1}-cmd "$@"; shift;;
  help) usage "$@"; exit 0;;
  *) usage; exit 1 ;;
esac

# Implement: add / rm / list / help / ... by this time i might as well make it a go cli...

# For this, we need to change the structure of rad-shell:
# Create a .rad-shell directory.  keep config here
# ~/.zshrc will import from .rad-plugins
# need to update dotfiles plugin to keep this working
# need to have some sort of dependency management thing
# I could include a static mapping for my plugins as a quick hack
