alias lg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs="git status"
alias gst="git stash"
alias gl="git pull"
alias gb="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias git-amend="git commit --amend --no-edit --reset-author"

really-really-amend() {
  local BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
  if [ "$BRANCH_NAME" = "master" ]; then
    echo "Don't do this on master, dummy"
    return 1
  fi

  git add . && git-amend && git push -f origin HEAD:$BRANCH_NAME
}
