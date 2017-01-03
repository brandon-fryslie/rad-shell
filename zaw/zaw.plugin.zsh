# Configure Zaw
bindkey '^X' zaw
bindkey '^R^R' zaw-history
bindkey "^e" accept-line
zstyle ':filter-select' max-lines 10
zstyle ':filter-select' max-lines -10
zstyle ':filter-select' hist-find-no-dups yes
zstyle ':filter-select' extended-search yes
zstyle ':filter-select' case-insensitive yes
zstyle ':filter-select' rotate-list yes
zstyle ':filter-select:highlight' selected fg=cyan,underline
zstyle ':filter-select:highlight' matched fg=yellow
zstyle ':filter-select:highlight' title fg=yellow,underline
