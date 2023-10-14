#!/usr/bin/env bash

set -e

colorize() { CODE=$1; shift; echo -e '\033[0;'"${CODE}m$*"'\033[0m'; }
bold() { echo -e "$(colorize 1 "$@")"; }
red() { echo -e "$(colorize '1;31' "$@")"; }
green() { echo -e "$(colorize 32 "$@")"; }
yellow() { echo -e "$(colorize 33 "$@")"; }

abort() {
  red "$1"
  red "Exiting..."
  exit 1
}

git --version 2>&1 | grep -q xcode-select && abort "Please install git before installing rad-shell.  On macOS, you should install the command line tools"

if [[ -f ~/.zshrc ]]; then
  yellow "Backing up ~/.zshrc to ~/.zshrc.$$.bak"
  mv ~/.zshrc ~/.zshrc.$$.bak
fi

yellow "Writing $HOME/.zshrc"
touch $HOME/.zshrc
cat <<-EOSCRIPT > $HOME/.zshrc
# Initialize rad-shell and plugins
source $HOME/.rad-shell/rad-init.zsh

# Add customizations below

EOSCRIPT

rad_plugins_file="$HOME/.rad-plugins"

write-default-plugins-file() {
  cat <<-EOSCRIPT > $rad_plugins_file
# Load Homebrew near the top
brandon-fryslie/rad-plugins homebrew

# Load some dotfile aliases
brandon-fryslie/rad-plugins dotfiles

# 3rd Party plugins
ohmyzsh/ohmyzsh plugins/docker

# Enhanced fork of zaw
brandon-fryslie/zaw
zsh-users/zsh-autosuggestions / develop
zsh-users/zsh-completions

brandon-fryslie/rad-plugins zaw
brandon-fryslie/rad-plugins docker
brandon-fryslie/rad-plugins git
brandon-fryslie/rad-plugins shell-tools
brandon-fryslie/rad-plugins rad-dev

### Themes
### Add themes here.  We use git-taculous by default.  You can also use most oh-my-zsh themes or a custom theme
### Remove or comment out the default theme if you want to use a different them
brandon-fryslie/rad-plugins git-taculous-theme/git-taculous

# oh-my-zsh theme example (https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
# ohmyzsh/ohmyzsh themes/amuse

# Custom theme example
# caiogondim/bullet-train-oh-my-zsh-theme bullet-train
### / Themes

# Load these last
brandon-fryslie/zsh-syntax-highlighting
brandon-fryslie/rad-plugins shell-customize
EOSCRIPT
}

if [[ ${SKIP_DEFAULT_PLUGINS:-false} == true ]]; then
  yellow "Skipping install of default plugins.  Creating empty $rad_plugins_file"
  touch $rad_plugins_file
else
  yellow "Writing $rad_plugins_file with default plugins"
  write-default-plugins-file
fi

if [[ -d $HOME/.zgen ]]; then
  yellow "Zgen is already cloned.  Skipping clone"
else
  yellow "Cloning Zgen into $HOME/.zgen"
  git clone https://github.com/brandon-fryslie/zgen.git $HOME/.zgen
fi

curl --fail -o /tmp/rad-init.zsh https://raw.githubusercontent.com/brandon-fryslie/rad-shell/${RAD_BRANCH:-master}/rad-init.zsh

rad_repo_path="$HOME/.zgen/brandon-fryslie/rad-shell-master"
# install plugin repos, then symlink the rad-shell repo into ~/.rad-shell
zsh -c "source /tmp/rad-init.zsh"
ln -s $rad_repo_path $HOME/.rad-shell || abort "Error: Cannot symlink rad-shell repo to ~/.rad-shell"

# Check out RAD_BRANCH, if needed
if [[ -n $RAD_BRANCH ]]; then
  git -C $rad_repo_path config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
  git -C $rad_repo_path fetch
  git -C $rad_repo_path checkout $RAD_BRANCH
fi

green "Done!  Open a new shell."
