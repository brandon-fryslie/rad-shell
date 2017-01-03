#################################################################
# cd to a dir in ~/projects
# because we type that a lot
# includes tab completions
#################################################################
function proj {
  cd ~/projects/$1
}
_proj_completion() {
  reply=($(exec ls -m ~/projects | sed -e 's/,//g' | tr -d '\n'))
}
compctl -K _proj_completion proj
#################################################################
