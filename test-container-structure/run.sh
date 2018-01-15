#!/bin/zsh -el

script_dir="${0:a:h}"

get-test-filename() {
  echo "${script_dir}/${1}-tests.yaml "
}

get-test-args() {
  local tests=()
  if [[ $# -eq 0 ]]; then
    tests=($(get-test-filename rad) $(get-test-filename docker))
  else
    for t in "$@"; do
      tests+=$(get-test-filename $t)
    done
  fi
  echo $tests
}

test_str="$(get-test-args "$@")"

echo "Running tests: $test_str"

structure-test \
  -test.v \
  -image rad-shell \
  ${(@s/ /)test_str}
