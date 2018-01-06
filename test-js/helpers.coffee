_ = require 'lodash'
require 'colors'
temp = require 'temp'
fs = require 'fs'
util = require './util'
mexpect = require './mexpect'

Stacker = class Stacker
  constructor: (cmd = '', env = {}) ->
    stacker_bin = "#{__dirname}/../bin/stacker"
    @mproc = mexpect.spawn
      cmd: "#{stacker_bin} #{cmd}"
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
  # Create stacker config path
  dirPath = temp.mkdirSync()
  fs.mkdirSync("#{dirPath}/tasks")
  fs.writeFileSync "#{dirPath}/config.coffee", opt.stacker_config

  # Setup stacker config path
  opt.env ?= {}
  opt.env.STACKER_CONFIG_DIR = dirPath

  # Setup task configs
  if !_.isEmpty opt.task_config
    for name, config of opt.task_config
      fs.writeFileSync "#{dirPath}/tasks/#{name}.coffee", config

  stacker = new Stacker opt.cmd, opt.env
  fn(stacker).then ->
    stacker.exit()

module.exports = {
  with_container
}
