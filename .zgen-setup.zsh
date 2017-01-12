# Copy this to ~/.zgen-setup.zsh and add 'source ~/.zgen-setup.zsh' to your .zshrc file
# Modify freely to add new plugins

# Initialize the completion engine
ZGEN_AUTOLOAD_COMPINIT=1

# Automatically regenerate zgen configuration when ~/.zgen-setup.zsh changes
ZGEN_RESET_ON_CHANGE=~/.zgen-setup.zsh

# We need to set some options before we load Prezto for them to take effect
zstyle ':prezto:*:*' color 'yes'
zstyle ':completion:*:default' list-colors ''

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

  # Uncomment to enable Python support
  # zgen prezto python
  # zgen load robbyrussell/oh-my-zsh plugins/pip

  # Uncomment to enable Ruby support
  # zgen prezto ruby

  # Uncomment to enable Tmux support
  # zgen prezto tmux

  # Uncomment to enable Docker support
  # zgen load robbyrussell/oh-my-zsh plugins/docker
  # zgen load brandon-fryslie/rad-shell docker

  # Uncomment to enable NVM support
  # zgen load brandon-fryslie/rad-shell nvm-lazy-load

  zgen load zsh-users/zaw
  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-completions

  zgen load brandon-fryslie/rad-shell git
  zgen load brandon-fryslie/rad-shell shell-tools
  zgen load brandon-fryslie/rad-shell zaw

  # Load these plugins last
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load brandon-fryslie/rad-shell shell-customize

  # Theme
  zgen load brandon-fryslie/rad-shell git-taculous-theme/git-taculous

  zgen save
fi
