# Copy this to ~/.zgen-setup.zsh and add 'source ~/.zgen-setup.zsh' to your .zshrc file
# Modify freely to add new plugins

# Initialize the completion engine
ZGEN_AUTOLOAD_COMPINIT=1

# Automatically regenerate zgen configuration when ~/.zgen-setup.zsh changes
ZGEN_RESET_ON_CHANGE=~/.zgen-setup.zsh

zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:window-title' format '%n@%m'
zstyle ':prezto:module:terminal:tab-title' format '%s'

# Use bash-style word delimiters
autoload -U select-word-style
select-word-style bash

source "${HOME}/.zgen/zgen.zsh"
# If we haven't yet generated our static initialization script
if ! zgen saved; then

  # Loads prezto base and default plugins:
  # environment terminal editor history directory spectrum utility completion prompt
  zgen prezto

  # Extra prezto plugins
  zgen prezto fasd
  zgen prezto git
  zgen prezto history-substring-search
  # zgen prezto ruby

  # 3rd Party plugins
  zgen load robbyrussell/oh-my-zsh plugins/docker

  # Enhanced fork of zaw
  zgen load brandon-fryslie/zaw
  zgen load zsh-users/zsh-autosuggestions / develop
  zgen load zsh-users/zsh-completions

  # The zaw plugin needs to be before the other plugins that provide zaw sources
  zgen load brandon-fryslie/rad-shell zaw
  zgen load brandon-fryslie/rad-shell docker
  zgen load brandon-fryslie/rad-shell git
  zgen load brandon-fryslie/rad-shell nvm-lazy-load
  zgen load brandon-fryslie/rad-shell shell-tools

  # This adds the oh-my-zsh-custom/bin folder to your $PATH
  zgen load RallySoftware/oh-my-zsh-custom plugins/set-script-path

  # Load these plugins last
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load brandon-fryslie/rad-shell shell-customize

  # Theme
  zgen load brandon-fryslie/rad-shell git-taculous-theme/git-taculous

  zgen save
fi
