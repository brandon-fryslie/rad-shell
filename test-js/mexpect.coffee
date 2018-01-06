require('es6-promise').polyfill()

child_process = require 'child_process'
stream = require 'stream'
_ = require 'lodash'
assert = require 'assert'

# this should be a utility somewhere...

create_transform_stream = (fn, flush_fn) ->
  liner = new stream.Transform()
  liner._transform = (chunk, encoding, done) ->
    fn.call @, chunk, encoding
    done()

  if flush_fn?
    liner._flush = (done) ->
      flush_fn.call @
      done()

  liner

create_newline_transform_stream = ->
  create_transform_stream (chunk) ->
    data = chunk.toString()
    if @_lastLineData?
      data = @_lastLineData + data

    lines = data.split('\n')
    @_lastLineData = lines.pop()

    for line in lines
      @push "#{line}"

  , ->
    if @_lastLineData?
      @push @_lastLineData
      @_lastLineData = null


create_prefix_transform_stream = (prefix) ->
  create_transform_stream (line) ->
    @push "#{prefix} #{line}\n"

create_callback_transform_stream = (expectation, cb) ->
  assert_valid_expectation expectation

  create_transform_stream (line) ->
    line = line.toString().replace(/\u001b\[\d{0,2}m/g, '')
    if expectation.test? and expectation.test(line) or line.toString().indexOf?(expectation) > -1
      data = expectation.exec?(line) ? [expectation]
      cb data

clone_apply = (obj1, obj2) ->
  newObj = {}
  newObj[k] = v for k, v of obj1
  newObj[k] = v for k, v of obj2
  newObj

assert_valid_expectation = (expectations) ->
  assert (_.isArray(expectations) && expectations.length) || _.isRegExp(expectations) || _.isString(expectations)

class Mexpect

  on_data: (expectations = '') =>
    expectations = [].concat expectations
    output = []

    assert_valid_expectation expectations

    final = expectations.reduce (previous, expectation) =>
      previous.then =>
        @_on_data_single(expectation).then (data) ->
          output = output.concat data
          data
    , Promise.resolve()

    final.then (match) -> output

  _on_data_single: (expectation) ->
    new Promise (resolve, reject) =>
      cb_stream = create_callback_transform_stream expectation, (matches) =>
        @stdout.unpipe cb_stream
        resolve matches

      @stdout.pipe cb_stream


  on_err: (expectation) ->
    assert_valid_expectation expectation

    new Promise (resolve, reject) =>
      cb_stream = create_callback_transform_stream expectation, (matches) =>
        @stderr.unpipe cb_stream
        resolve matches

      @stderr.pipe cb_stream

  _spawn_bash: (cmd, opt) ->
    @proc = child_process.spawn 'bash', [], opt
    @proc.stdin.write "#{cmd.join(' ')}\n"
    @proc

  _spawn_direct: (cmd, opt) ->
    [cmd, argv...] = cmd
    @proc = child_process.spawn cmd, argv, opt

  # cmd: command to run
  # cwd: working dir for command (default: current process cwd)
  # env: shell env (default: current process env)
  # direct: run command directly (not using bash)
  spawn: (opt) =>
    {cmd, direct} = opt
    opt = _.omit opt, ['cmd', 'direct']

    cmd = if _.isArray(cmd) then cmd else [cmd]
    direct ?= false
    opt.cwd ?= process.cwd()
    opt.env = _.assign({}, process.env, opt.env)

    @proc = if direct
      @_spawn_direct cmd, opt
    else
      @_spawn_bash cmd, opt

    @stdout = @proc.stdout.pipe create_newline_transform_stream()
    @stderr = @proc.stderr.pipe create_newline_transform_stream()

    @on_close =
      new Promise (resolve, reject) =>
        @proc.on 'close', (code, signal) ->
          resolve [code, signal]

    @


module.exports.spawn = ->
  mexpect = new Mexpect
  mexpect.spawn.apply mexpect, arguments
  mexpect
