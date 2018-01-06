#!/usr/bin/env bats

rad_shell_dir="/Users/brandon.fryslie/.zgen/brandon-fryslie/rad-shell-master"

@test "can install rad-shell" {
  # build the docker container
  export IMAGE_NAME=rad-shell-test
  $rad_shell_dir/docker/build.sh
  # run it, verify rad shell works

  run docker run $IMAGE_NAME zsh -c 'echo $RAD_SHELL_DIR'
  echo $output &>2
}
