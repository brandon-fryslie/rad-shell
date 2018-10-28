_ = require 'lodash'
require 'colors'
temp = require 'temp'
fs = require 'fs'
util = require './util'
mexpect = require './mexpect'

ContainerCmd = class ContainerCmd
  constructor: (cmd, image_name, env = {}) ->
    @container_name = "rad-shell-test-helper-#{Math.floor((Math.random() * 999) + 100)}"
    docker_sock = "/var/run/docker.sock"
    if !cmd? or !image_name?
      throw "ContainerCmd: must provide cmd and image_name"
    @cmd = "docker run --name #{@container_name} -v #{docker_sock}:#{docker_sock} #{image_name} zsh -l -c '#{cmd}'"
    @mproc = mexpect.spawn
      cmd: @cmd
      env: env

  wait: ({ success, failure }) ->
    Promise.race([
      @wait_for(@mproc, success),
      @wait_for_err(@mproc, failure).then (matches) =>
        throw new Error "Command failed: #{this.cmd}\n#{matches.join('\n')}".red
    ])

  wait_for: (mproc, expectation) ->
    mproc.on_data expectation

  wait_for_err: (mproc, expectation) ->
    mproc.on_err expectation

  kill: ->
    @mproc.proc.kill('SIGINT')

  wait_cmd: (cmd, { success, failure }) ->
    docker_cmd = "docker exec #{@container_name} #{cmd}"
    mproc = mexpect.spawn cmd: docker_cmd
    Promise.race([
      @wait_for(mproc, success),
      @wait_for_err(mproc, failure).then (matches) =>
        throw new Error "Command failed: #{cmd}\n#{matches.join('\n')}".red
    ])

  engageOutput: ->
    util.pipe_with_prefix "--- #{@cmd}:".magenta, @mproc.proc.stdout, process.stdout
    util.pipe_with_prefix "--- #{@cmd}:".magenta, @mproc.proc.stderr, process.stderr

start_container = (opt) ->
  container = new ContainerCmd opt.cmd, opt.image_name, opt.env
  container.engageOutput() if opt.engageOutput
  container

wait_for_container = (container_name) ->
  mproc = mexpect.spawn
    cmd: "echo aaaa"
  mproc.on_data /aaaa/

with_container = (opt, fn) ->
  container = new ContainerCmd opt.cmd, opt.image_name, opt.env
  container.engageOutput() if opt.engageOutput
  fn(container).then ->
    container.kill()

module.exports = {
  with_container,
  start_container,
  wait_for_container
}
