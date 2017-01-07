# Copy this to ~/.zgen-setup.zsh and add 'source ~/.zgen-setup.zsh' to your .zshrc file
# Modify freely to add new plugins

# Initialize the completion engine
# This adds a significant amount of startup time (~0.5 seconds)
# Disable this if you want to sacrifice completions for moar speed
ZGEN_AUTOLOAD_COMPINIT=1

# Automatically regenerate zgen configuration when ~/.zgen-setup.zsh changes
ZGEN_RESET_ON_CHANGE=~/.zgen-setup.zsh

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
  zgen prezto python
  zgen prezto ruby
  zgen prezto tmux

  # 3rd Party plugins
  zgen load robbyrussell/oh-my-zsh plugins/docker
  zgen load robbyrussell/oh-my-zsh plugins/pip

  zgen load zsh-users/zaw
  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-completions
  zgen load zsh-users/zsh-syntax-highlighting

  zgen load brandon-fryslie/rad-shell git
  zgen load brandon-fryslie/rad-shell nvm-lazy-load
  zgen load brandon-fryslie/rad-shell shell-customize
  zgen load brandon-fryslie/rad-shell shell-tools
  zgen load brandon-fryslie/rad-shell zaw

  # Theme
  zgen load brandon-fryslie/rad-shell git-taculous-theme/git-taculous

  zgen save
fi
