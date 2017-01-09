# Colors
zstyle ':prezto:*:*' color 'yes'
zstyle ':completion:*:default' list-colors ''
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

# Configure the syntax highlighter a little
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold,underline'
ZSH_HIGHLIGHT_PATTERNS+=('$[a-zA-Z0-9_]#' 'fg=cyan,underline') # Shell variables

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
