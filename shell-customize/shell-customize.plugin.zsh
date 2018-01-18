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

set -o append_history
set -o extended_history
set -o hist_expire_dups_first
set -o hist_ignore_all_dups
set -o hist_ignore_space
set -o hist_reduce_blanks
set -o hist_verify
set -o inc_append_history
set -o share_history
set +o noclobber # Allow overwriting of files by redirection (many scripts assume this behavior)

## / Command history configuration

# Just so we have something
export EDITOR=vi

realpath_rad ()
{
    local f base dir
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
