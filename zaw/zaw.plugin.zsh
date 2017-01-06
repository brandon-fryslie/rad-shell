# Configure Zaw

# Visual/Behavioral stuff
zstyle ':filter-select' max-lines 10
zstyle ':filter-select' max-lines -10
zstyle ':filter-select' hist-find-no-dups yes
zstyle ':filter-select' extended-search yes
zstyle ':filter-select' case-insensitive yes
zstyle ':filter-select' rotate-list yes
zstyle ':filter-select:highlight' selected fg=cyan,underline
zstyle ':filter-select:highlight' matched fg=yellow
zstyle ':filter-select:highlight' title fg=yellow,underline

# Key bindings
bindkey '^[Z' zaw
bindkey '^R^R' zaw-history
bindkey '^[D' zaw-fasd-directories
bindkey '^[F' zaw-fasd-files
bindkey '^[B' zaw-git-branches
bindkey '^[O' zaw-git-files
bindkey '^[L' zaw-git-log
bindkey '^[R' zaw-git-reflog
bindkey '^[S' zaw-git-status

# These bindings take effect when using zaw
bindkey -M filterselect '^M' accept-line # Enter
bindkey -M filterselect '^[^M' accept-search # Escape + Enter

bindkey -M filterselect '^[F' forward-word # Escape + F
bindkey -M filterselect '^[B' backward-word # Escape + B

bindkey -M filterselect '^[,' beginning-of-history # Escape + <
bindkey -M filterselect '^[.' end-of-history # Escape + >
