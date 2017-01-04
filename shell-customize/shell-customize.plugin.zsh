# Colors
zstyle ':prezto:*:*' color 'yes'
zstyle ':completion:*:default' list-colors ''
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

# Enable prompts in git-taculous theme
ENABLE_NODE_PROMPT=true
ENABLE_DOCKER_PROMPT=true

# Share history between terminal windows
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS
HISTFILE=~/.zsh_history
HISTSIZE=99999999
SAVEHIST=$HISTSIZE
