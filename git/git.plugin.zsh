source "${0:a:h}/git-zaw.zsh"
source "${0:a:h}/git-status-zaw.zsh"

alias gb="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gd="git diff"
alias gds="git diff --staged"
alias git-amend="git commit --amend --no-edit --reset-author"
alias gl="git pull"
alias gs="git status"
alias gst="git stash"
alias lg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"

really-really-amend() {
  local BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
  if [ "$BRANCH_NAME" = "master" ]; then
    echo "Don't do this on master, dummy"
    return 1
  fi

  git add . && git-amend && git push -f origin HEAD:$BRANCH_NAME
}
