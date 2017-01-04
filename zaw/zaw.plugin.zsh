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
bindkey '^X' zaw
bindkey '^R^R' zaw-history

# These bindings take effect when using zaw

# accept-line puts the line into the prompt without executing it
# accept-search executes it immediately
bindkey -M filterselect '^[^M' accept-line # Escape + Enter
bindkey -M filterselect '^M' accept-search # Enter

bindkey -M filterselect '^[F' forward-word # Escape + F
bindkey -M filterselect '^[B' backward-word # Escape + B

bindkey -M filterselect '^[,' beginning-of-history # Escape + <
bindkey -M filterselect '^[.' end-of-history # Escape + >
