# rad zstyle functions
rad-zstyle-set() {
  local context=$1 style=$2 varname=$3
  zstyle -- ":radsh:${context}:" "${style}" "${varname}"
}

rad-zstyle-get() {
  local context=$1 style=$2 varname=${3:-REPLY}
  zstyle -g "${varname}" ":radsh:${context}:" "${style}"
  echo $REPLY
}

rad-zstyle-test() {
  local context=$1 style=$2
  zstyle -t ":radsh:${context}:" "${style}"
}
# / rad zstyle functions
