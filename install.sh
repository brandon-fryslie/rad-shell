#!/bin/bash -el

colorize() { CODE=$1; shift; echo -e '\033[0;'$CODE'm'$*'\033[0m'; }
bold() { echo -e "$(colorize 1 "$@")"; }
red() { echo -e "$(colorize '1;31' "$@")"; }
green() { echo -e "$(colorize 32 "$@")"; }
yellow() { echo -e "$(colorize 33 "$@")"; }

abort() {
  red $1
  red "Exiting..."
  exit 1
}

if [[ -f ~/.zshrc ]]; then
  [[ -f ~/.zshrc.bak ]] && { abort "Error: both ~/.zshrc and ~/.zshrc.bak exit.  Move one of them"; }
  yellow "Backing up ~/.zshrc to ~/.zshrc.bak"
  mv ~/.zshrc ~/.zshrc.bak
fi

rad_dir="$HOME/.rad-shell"
rad_init_file="$rad_dir/rad-init.zsh"
rad_plugins_file="$rad_dir/rad-plugins.zsh"

yellow "Creating $rad_dir"
mkdir -p $rad_dir

yellow "Writing $HOME/.zshrc"
touch ~/.zshrc
cat <<-EOSCRIPT > ~/.zshrc
# Initialize rad-shell and plugins
source $rad_dir/rad-init.zsh

# Add customizations below

EOSCRIPT

yellow "Writing $rad_init_file"
touch $rad_init_file
cat <<-EOSCRIPT > $rad_init_file
# Initialize the completion engine
ZGEN_AUTOLOAD_COMPINIT=1

# Automatically regenerate zgen configuration when ~/.zgen-setup.zsh changes
ZGEN_RESET_ON_CHANGE=$rad_plugins_file

zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:window-title' format '%n@%m'
zstyle ':prezto:module:terminal:tab-title' format '%s'

# Use bash-style word delimiters
autoload -U select-word-style
select-word-style bash

source "${HOME}/.zgen/zgen.zsh"
# if the init scipt doesn't exist
if ! zgen saved; then

  # Loads prezto base and default plugins:
  # environment terminal editor history directory spectrum utility completion prompt
  zgen prezto

  # Extra prezto plugins
  zgen prezto fasd
  zgen prezto git
  zgen prezto history-substring-search

  # Initializes some functionality baked into rad-shell
  zgen load brandon-fryslie/rad-shell init-plugin

  # Here is where we need to load the plugins from $HOME/.rad-plugins

  # Theme
  zgen load brandon-fryslie/rad-shell git-taculous-theme/git-taculous

  zgen save
fi
EOSCRIPT

# Create plugins file
touch $rad_plugins_file

if [[ -d $HOME/.zgen ]]; then
  yellow "Zgen is already cloned.  Skipping clone"
else
  yellow "Cloning Zgen into $HOME/.zgen"
  git clone https://github.com/brandon-fryslie/zgen.git $HOME/.zgen
fi

green "Done!  Open a new shell."
