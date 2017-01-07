# Colors
zstyle ':prezto:*:*' color 'yes'
zstyle ':completion:*:default' list-colors ''
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

# Share history between terminal windows
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS
HISTFILE=~/.zsh_history
HISTSIZE=99999999
SAVEHIST=$HISTSIZE

# Just so we have something
export EDITOR=vi
