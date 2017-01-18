# Configure the syntax highlighter a little
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold,underline'
ZSH_HIGHLIGHT_PATTERNS+=('$[a-zA-Z0-9_]#' 'fg=cyan,underline') # Shell variables

## Command history configuration
## Copied & modified from oh-my-zsh history plugin
HISTFILE=$HOME/.zsh_history

HISTSIZE=100000
SAVEHIST=100000

# Show history
case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history
## / Command history configuration

# Setup path for homebrew
type brew &>/dev/null && export PATH="/usr/local/sbin:$PATH"

# Just so we have something
export EDITOR=vi
