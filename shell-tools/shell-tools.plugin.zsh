#################################################################
# cd to a dir in ~/projects
# because we type that a lot
# includes tab completions
#################################################################

PROJECTS_DIR=${PROJECTS_DIR:-${HOME}/projects}

function proj {
  cd "${PROJECTS_DIR}/$1"
}
_proj_completion() {
  reply=($(exec ls -m "${PROJECTS_DIR}" | sed -e 's/,//g' | tr -d '\n'))
}
compctl -K _proj_completion proj
#################################################################
