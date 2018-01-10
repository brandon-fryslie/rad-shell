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
rad_plugins_file="$HOME/.rad-plugins"

yellow "Creating $rad_dir"
mkdir -p $rad_dir

yellow "Writing $HOME/.zshrc"
touch ~/.zshrc
cat <<-EOSCRIPT > ~/.zshrc
# Initialize rad-shell and plugins
source $rad_dir/rad-init.zsh

# Add customizations below

EOSCRIPT

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
yellow "Copying $script_dir/rad-init.zsh to $rad_init_file"
cp $script_dir/rad-init.zsh $rad_init_file

yellow "Creating $rad_plugins_file"
touch $rad_plugins_file

if [[ -d $HOME/.zgen ]]; then
  yellow "Zgen is already cloned.  Skipping clone"
else
  yellow "Cloning Zgen into $HOME/.zgen"
  git clone https://github.com/brandon-fryslie/zgen.git $HOME/.zgen
fi

# install repos, then symlink the rad-shell repo into ~/.rad-shell
zsh -l -c "source ~/.zshrc"

rm -rf rad-shell
ln -s $HOME/.zgen/brandon-fryslie/rad-shell-master $HOME/.rad-shell

green "Done!  Open a new shell."
