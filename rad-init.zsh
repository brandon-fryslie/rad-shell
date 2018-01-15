# Initialize the completion engine
ZGEN_AUTOLOAD_COMPINIT=1

# Automatically regenerate zgen configuration when ~/.rad-plugins changes
ZGEN_RESET_ON_CHANGE=$HOME/.rad-plugins

zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:window-title' format '%n@%m'
zstyle ':prezto:module:terminal:tab-title' format '%s'

# Remove alias 'rm' -> 'rm -i' if it exists
alias rm &>/dev/null && unalias rm

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

  # Here is where we load plugins from $HOME/.rad-plugins
  while read -r line; do
    if [[ ! $line =~ '^#' ]] && [[ ! $line == '' ]]; then
      echo "Loading plugin: $line"
      eval "zgen load $line"
    fi
  done < $HOME/.rad-plugins

  # Theme
  zgen load brandon-fryslie/rad-plugins git-taculous-theme/git-taculous

  zgen save
fi
