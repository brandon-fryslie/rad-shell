# Colors
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

zstyle ':prezto:*:*' color 'yes'
zstyle ':completion:*:default' list-colors ''

# Configure the syntax highlighter a little
if typeset -p ZSH_HIGHLIGHT_HIGHLIGHTERS > /dev/null 2>&1; then
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold,underline'
  ZSH_HIGHLIGHT_PATTERNS+=('$[a-zA-Z0-9_]#' 'fg=cyan,underline') # Shell variables
fi

## Command history configuration
## Copied & modified from oh-my-zsh history plugin
HISTFILE=$HOME/.zsh_history

HISTSIZE=10000
SAVEHIST=10000

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

realpath_rad ()
{
    f=$@;
    if [ -d "$f" ]; then
        base="";
        dir="$f";
    else
        base="/$(basename "$f")";
        dir=$(dirname "$f");
    fi;
    dir=$(cd "$dir" && /bin/pwd);
    echo "$dir$base"
}

# Add rad-shell/bin to PATH
export PATH="$(realpath_rad "${0:a:h}/../bin"):$PATH"
