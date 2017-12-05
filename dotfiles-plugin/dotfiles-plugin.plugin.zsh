alias .rc="source $HOME/.zshrc"
alias cd.rc="$HOME/dotfiles"
e.rc() { $(rad-get-visual-editor) $HOME/dotfiles; }
e.rad() { ${VISUAL:-${EDITOR:-vi}} $HOME/.zgen/brandon-fryslie/rad-shell-master; }
