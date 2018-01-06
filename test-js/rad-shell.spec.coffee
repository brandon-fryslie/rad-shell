#fs = require 'fs'
#_ = require 'lodash'
#temp = require('temp').track()
parallel = require 'mocha.parallel'
#{with_container} = require './helpers'
util = require './util'
mexpect = require './mexpect'
#

rad_shell_dir = "#{__dirname}/.."

ContainerCmd = class ContainerCmd
  constructor: (cmd, image_name, env = {}) ->
    if !cmd? or !image_name?
      throw "ContainerCmd: must provide cmd and image_name"
    @mproc = mexpect.spawn
      cmd: "docker run #{image_name} #{cmd}"
      env: env
# @engageOutput()

  wait_for: (expectation) ->
    @mproc.on_data expectation

  send_cmd: (cmd) ->
    @mproc.proc.stdin.write "#{cmd}\n"

  engageOutput: ->
    util.pipe_with_prefix '---- stacker output'.magenta, @mproc.proc.stdout, process.stdout
    util.pipe_with_prefix '---- stacker output'.magenta, @mproc.proc.stderr, process.stderr

  exit: ->
    @send_cmd 'exit'
    # The snowman is there to handle the case where stacker displays usage information and exits
    @wait_for(/Killed running tasks!|☃/)

with_container = (opt, fn) ->
  container = new ContainerCmd opt.cmd, opt.image_name, opt.env
  container.engageOutput() if opt.engageOutput
  fn(container).then ->
    container.exit()

describe 'rad-shell', ->
  it 'can install rad-shell', ->
    docker_image_name = 'rad-shell-test'
    @timeout 5 * 60 * 1000

    build_proc = mexpect.spawn
      cmd: "#{rad_shell_dir}/docker/build.sh"
      env:
        IMAGE_NAME: docker_image_name

    util.pipe_with_prefix '---- command output'.magenta, build_proc.proc.stdout, process.stdout
    util.pipe_with_prefix '---- command output'.magenta, build_proc.proc.stderr, process.stderr

    build_proc.on_data("Successfully tagged #{docker_image_name}:latest").then ->
      console.log 'Built Image!'

      with_container
        cmd: 'rad.sh version'
        image_name: docker_image_name
        engageOutput: true
      , (container) ->
        container.wait_for('0.2.0')
        container.mproc.on_err(/.*/).then (matches) ->
#          console.log('got output on stderr:')
#          console.log(matches)
          throw new Error(matches.join('\n'))
