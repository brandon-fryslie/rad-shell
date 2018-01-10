_ = require 'lodash'
require 'colors'
temp = require 'temp'
fs = require 'fs'
util = require './util'
mexpect = require './mexpect'

ContainerCmd = class ContainerCmd
  constructor: (cmd, image_name, env = {}) ->
    if !cmd? or !image_name?
      throw "ContainerCmd: must provide cmd and image_name"
    @cmd = "docker run #{image_name} zsh -l -c '#{cmd}'"
    @mproc = mexpect.spawn
      cmd: @cmd
      env: env

  wait: ({success, failure}) ->
    Promise.race([
      @wait_for(success),
      @wait_for_err(failure).then (matches) ->
        throw new Error "Command failed: #{container.cmd}\n#{matches.join('\n')}".red
    ])

  wait_for: (expectation) ->
    @mproc.on_data expectation

  wait_for_err: (expectation) ->
    @mproc.on_err expectation

  kill: ->
    @mproc.proc.kill('SIGINT')

  send_cmd: (cmd) ->
    @mproc.proc.stdin.write "#{cmd}\n"

  engageOutput: ->
    util.pipe_with_prefix "--- #{@cmd}:".magenta, @mproc.proc.stdout, process.stdout
    util.pipe_with_prefix "--- #{@cmd}:".magenta, @mproc.proc.stderr, process.stderr

with_container = (opt, fn) ->
  container = new ContainerCmd opt.cmd, opt.image_name, opt.env
  container.engageOutput() if opt.engageOutput
  fn(container).then ->
    container.kill()

module.exports = {
  with_container
}
