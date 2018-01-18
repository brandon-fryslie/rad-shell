#!/usr/bin/env bats

@test "dhost: can set docker host" {
  dhost MY_DOCKER_HOST
  [[ "$DOCKER_HOST" == "DOCKER_HOST=tcp://MY_DOCKER_HOST:2375" ]]
}
