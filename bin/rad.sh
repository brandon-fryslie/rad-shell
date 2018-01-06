#!/usr/bin/env zsh -l

# Script to manage rad-shell installation

set -e

colorize() { CODE=$1; shift; echo -e '\033[0;'$CODE'm'$*'\033[0m'; }
bold() { echo -e "$(colorize 1 "$@")"; }
red() { echo -e "$(colorize '1;31' "$@")"; }
green() { echo -e "$(colorize 32 "$@")"; }
yellow() { echo -e "$(colorize 33 "$@")"; }

script_dir="$( cd "$( dirname "${0:a:h}" )" && pwd )"

# Command functions
plugin-cmd() {
  local command=$1
}

version-cmd() {
  cat $script_dir/VERSION
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
  plugin) plugin-cmd "$@"; shift;;
  version) version-cmd "$@";;
  *)
    usage
    exit 1
  ;;
esac

# Implement: add / rm / list

# For this, we need to change the structure of rad-shell:
# Create a .rad-shell directory.  keep config here
# ~/.zshrc will import from .rad-shell/.zgen-setup.zsh
# need to update dotfiles plugin to keep this working
# need to have some sort of dependency management thing
# I could include a static mapping for my plugins as a quick hack
