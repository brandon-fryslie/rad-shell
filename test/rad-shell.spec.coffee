#fs = require 'fs'
#_ = require 'lodash'
#temp = require('temp').track()
parallel = require 'mocha.parallel'
{with_container} = require './helpers'
util = require './util'
mexpect = require './mexpect'
assert = require 'assert'

rad_shell_dir = "#{__dirname}/.."

describe 'rad-shell', ->
  it 'can install rad-shell', ->
    docker_image_name = 'rad-shell-test'
    @timeout 20 * 60 * 1000

    cmd = "#{rad_shell_dir}/docker-image/build.sh --no-cache --build-arg RAD_SHELL_BRANCH=#{process.env.RAD_SHELL_BRANCH ? 'master'}"
    build_proc = mexpect.spawn
      cmd: cmd
      env:
        IMAGE_NAME: docker_image_name

    util.pipe_with_prefix '--- docker build output'.magenta, build_proc.proc.stdout, process.stdout
    util.pipe_with_prefix '--- docker build output'.magenta, build_proc.proc.stderr, process.stderr

    # We have to return both promises, one for failure and one for success or mocha complains
    Promise.race([
      build_proc.on_data("Successfully tagged #{docker_image_name}:latest").then ->
        with_container
          cmd: 'rad.sh version'
          image_name: docker_image_name
          engageOutput: true
        , (container) ->
          container.wait
            success: '0.2.0'
            failure: /.*/

      build_proc.on_err(/The command.*returned a non-zero code/).then (matches) ->
        assert.fail matches.join '\n'
    ])
