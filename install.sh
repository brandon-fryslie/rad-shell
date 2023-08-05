#!/usr/bin/env bash

set -e

colorize() { CODE=$1; shift; echo -e '\033[0;'"${CODE}m$*"'\033[0m'; }
bold() { echo -e "$(colorize 1 "$@")"; }
red() { echo -e "$(colorize '1;31' "$@")"; }
green() { echo -e "$(colorize 32 "$@")"; }
yellow() { echo -e "$(colorize 33 "$@")"; }

abort() {
<<<<<<< HEAD
  red "$1"
  red "Exiting..."
=======
  red $1
>>>>>>> c863ba4 (refactor install wip)
  exit 1
}

detect_os_type() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
      # This is macOS
      echo "MacOS"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      # This is Linux
      echo "Linux"
  elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
      # This is Windows (Cygwin or MSYS/MinGW)
      echo "Windows"
  else
      # Unsupported OS or unable to determine OS
      red "ERROR: My apologoies, we couldn't determine your operating system :("
      red "ERROR: I would so much appreciate it if you could file an issue here: https://github.com/brandon-fryslie/rad-shell/issues"
      red "ERROR: or let me know in some way.  Please include the following information:"
      red "ERROR: \$OSTYPE variable was '$OSTYPE'"
  fi
}

prompt_yes_no() {
  local prompt=$1
  local cmdYes=$2
  local cmdNo=$3
  local response

  while true; do
    read -r -p "${prompt}" response

    if [[ "$response" =~ ^[Yy]$ ]]; then
      eval "$cmdYes"
      return 0
    elif [[ "$response" =~ ^[Nn]$ ]]; then
      eval "$cmdNo"
      return 0
    else
      yellow "Please enter 'y' or 'n', or ctrl+c to exit"
    fi
  done
}


install-macos() {
  yellow "Checking for git..."
  if git --version 2>&1 | grep -q xcode-select || ! command -v "git" >/dev/null 2>&1; then
    prompt_yes_no "Please install the MacOS Command Line Tools.  Would you like to install them now? (y/n): "\
      "xcode-select --install" \
      "abort 'Cannot continue without git, goodbye'"
  else
    green "git found"
  fi


}


install-linux() {
  yellow "Checking for git..."
  command -v "git" >/dev/null 2>&1 || abort "Please install git before installing rad-shell.  Use your system package manager or any preferred source"
}

############ main ############

os_name="$(detect_os_type)"

# There's a few MacOS specific things, but treat Windows like Linux
if [[ $os_name == "MacOS"]]; then
  install-macos
else
  install-linux
fi
exit 0

if [[ -f ~/.zshrc ]]; then
  yellow "Backing up ~/.zshrc to ~/.zshrc.$$.bak"
  mv ~/.zshrc ~/.zshrc.$$.bak
fi

yellow "Writing $HOME/.zshrc"
touch "$HOME/.zshrc"
cat <<-EOSCRIPT > "$HOME/.zshrc"
# Initialize rad-shell and plugins
source $HOME/.rad-shell/rad-init.zsh

# Add customizations below

EOSCRIPT

rad_plugins_file="$HOME/.rad-plugins"

write-default-plugins-file() {
  cat <<-EOSCRIPT > "$rad_plugins_file"
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
  touch "$rad_plugins_file"
else
  yellow "Writing $rad_plugins_file with default plugins"
  write-default-plugins-file
fi

if [[ -d $HOME/.zgen ]]; then
  yellow "Zgen is already cloned.  Skipping clone"
else
  yellow "Cloning Zgen into $HOME/.zgen"
  git clone https://github.com/brandon-fryslie/zgen.git "$HOME/.zgen"
fi

curl --fail -o /tmp/rad-init.zsh "https://raw.githubusercontent.com/brandon-fryslie/rad-shell/${RAD_BRANCH:-master}/rad-init.zsh"

rad_repo_path="$HOME/.zgen/brandon-fryslie/rad-shell-master"
# install plugin repos, then symlink the rad-shell repo into ~/.rad-shell
zsh -c "source /tmp/rad-init.zsh"
ln -s "$rad_repo_path" "$HOME/.rad-shell" || abort "Error: Cannot symlink rad-shell repo to ~/.rad-shell"

# Check out RAD_BRANCH, if needed
if [[ -n $RAD_BRANCH ]]; then
  git -C "$rad_repo_path" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
  git -C "$rad_repo_path" fetch
  git -C "$rad_repo_path" checkout "$RAD_BRANCH"
fi

green "Done!  Open a new shell."
