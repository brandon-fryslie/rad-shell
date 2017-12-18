#!/usr/bin/env bash

colorize() { CODE=$1; shift; echo -e '\033[0;'$CODE'm'$@'\033[0m'; }
bold() { echo -e $(colorize 1 $@); }
red() { echo -e $(colorize 31 $@); }
green() { echo -e $(colorize 32 $@); }
yellow() { echo -e $(colorize 33 $@); }
reset() { tput sgr0; }

abort() {
  echo `red $1`
  echo `red "Exiting..."`
  exit 1
}

if [[ -f ~/.zshrc ]]; then
  [[ -f ~/.zshrc.bak ]] && { abort "Error: both ~/.zshrc and ~/.zshrc.bak exit.  Move one of them"; }
  yellow "Backing up ~/.zshrc to ~/.zshrc.bak"
  mv ~/.zshrc ~/.zshrc.bak
fi

yellow "Writing $HOME/.zshrc"
touch ~/.zshrc
cat <<-EOSCRIPT > ~/.zshrc
# Source Zgen and create init file if necessary
# Add custom Zsh plugins to .zgen-setup.zsh
source ~/.zgen-setup.zsh

# Add customizations below

EOSCRIPT

# TODO: detect and install command line tools if needed

# Make this interactive
yellow "Writing $HOME/.zgen-setup.zsh"
zgen_setup_url="https://raw.githubusercontent.com/brandon-fryslie/rad-shell/master/.zgen-setup.zsh"
curl -o- $zgen_setup_url > ~/.zgen-setup.zsh \
  || wget -q0- $zgen_setup_url > ~/.zgen-setup.zsh

if [[ -d $HOME/.zgen ]]; then
  yellow "Zgen is already cloned.  Skipping clone"
else
  yellow "Cloning Zgen into $HOME/.zgen"
  git clone https://github.com/brandon-fryslie/zgen.git $HOME/.zgen
fi

# Install 'brew' if not installed
if [[ (( $+commands[brew] )) ]]; then
  yellow "Homebrew not installed.  Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if [[ $(uname) == Darwin ]]; then
  yellow "Installing Fasd"
  brew install fasd
fi

green "Done!  Open a new shell."
