#fs = require 'fs'
#_ = require 'lodash'
#temp = require('temp').track()
parallel = require 'mocha.parallel'
#{with_container} = require './helpers'
util = require './util'
mexpect = require './mexpect'
#

rad_shell_dir = "#{__dirname}/.."

describe 'rad-shell', ->
  it 'can install rad-shell', ->
    docker_image_name = 'rad-shell-test'
    @timeout 120 * 1000

    build_proc = mexpect.spawn
      cmd: "#{rad_shell_dir}/docker/build.sh"
      env:
        IMAGE_NAME: docker_image_name

    util.pipe_with_prefix '---- command output'.magenta, build_proc.proc.stdout, process.stdout
    util.pipe_with_prefix '---- command output'.magenta, build_proc.proc.stderr, process.stderr

    build_proc.on_data("Successfully tagged #{docker_image_name}:latest").then ->
      console.log 'Built Image!'
      run_proc = mexpect.spawn
        cmd: "docker run #{docker_image_name} zsh -c 'rad.sh version"
      util.pipe_with_prefix '---- command output'.magenta, run_proc.proc.stdout, process.stdout
      util.pipe_with_prefix '---- command output'.magenta, run_proc.proc.stderr, process.stderr

      run_proc.on_data('0.2.0')
