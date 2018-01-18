#!/bin/bash

set -e

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

readkey() {
  while true; do
    read -r input
    echo $input
    break
  done
}
git --version 2>&1 | grep -q xcode-select && abort "Please install the macOS command line tools before installing rad-shell"

if [[ -f ~/.zshrc ]]; then
  [[ -f ~/.zshrc.bak ]] && { abort "Error: both ~/.zshrc and ~/.zshrc.bak exit.  Move one of them"; }
  yellow "Backing up ~/.zshrc to ~/.zshrc.bak"
  mv ~/.zshrc ~/.zshrc.bak
fi

yellow "Writing $HOME/.zshrc"
touch $HOME/.zshrc
cat <<-EOSCRIPT > $HOME/.zshrc
# Initialize rad-shell and plugins
source $HOME/.rad-shell/rad-init.zsh

# Add customizations below

EOSCRIPT

rad_plugins_file="$HOME/.rad-plugins"
yellow "Creating $rad_plugins_file"

write-default-plugins-file() {
  cat <<-EOSCRIPT > $rad_plugins_file
# Load Homebrew near the top
brandon-fryslie/rad-plugins homebrew

# Load some dotfile aliases
brandon-fryslie/rad-plugins dotfiles

# 3rd Party plugins
robbyrussell/oh-my-zsh plugins/docker

# Enhanced fork of zaw
brandon-fryslie/zaw
zsh-users/zsh-autosuggestions / develop
zsh-users/zsh-completions

brandon-fryslie/rad-plugins zaw
brandon-fryslie/rad-plugins docker
brandon-fryslie/rad-plugins git
brandon-fryslie/rad-plugins shell-tools
brandon-fryslie/rad-plugins rad-dev

# Load these last
brandon-fryslie/zsh-syntax-highlighting
brandon-fryslie/rad-plugins shell-customize
EOSCRIPT
}

ask-install-default-plugins() {
  yellow "---"
  green "Do you want to install the default plugins? [Y/N]"
  green "The default plugins include:"
  green " - filterlists and aliases for docker and git"
  green " - syntax highlighting"
  green " - completions"
  green " - useful aliases and customizations"
  green ""
  green "You can add or remove plugins by editing ~/.rad-plugins"
  yellow "---"
  case "$(readkey)" in
    y|Y*) write-default-plugins-file ;;
    n|N*) rad-yellow "Skipping install of default plugins" ;;
    *) ask-install-default-plugins ;;
  esac
}

ask-install-default-plugins

if [[ -d $HOME/.zgen ]]; then
  yellow "Zgen is already cloned.  Skipping clone"
else
  yellow "Cloning Zgen into $HOME/.zgen"
  git clone https://github.com/brandon-fryslie/zgen.git $HOME/.zgen
fi

curl --fail -o /tmp/rad-init.zsh https://raw.githubusercontent.com/brandon-fryslie/rad-shell/bmf_add_container_tests/rad-init.zsh

# install repos, then symlink the rad-shell repo into ~/.rad-shell
zsh -c "source /tmp/rad-init.zsh"
ln -s $HOME/.zgen/brandon-fryslie/rad-shell-master $HOME/.rad-shell || abort "Error: Cannot symlink rad-shell repo to ~/.rad-shell"

green "Done!  Open a new shell."
