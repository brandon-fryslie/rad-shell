parallel = require 'mocha.parallel'
assert = require 'assert'
mexpect = require './/mexpect'

assert_exit_status = (cmd, expected_code, expected_signal) ->
  mproc = mexpect.spawn { cmd }
  mproc.proc.stdin.end()
  mproc.on_close.then ([code, signal]) ->
    assert.equal code, expected_code
    assert.equal signal, expected_signal if expected_signal

spawn_and_match = (cmd, expectation) ->
  mexpect.spawn { cmd }
  .on_data expectation

spawn_and_match_err = (cmd, expectation) ->
  mexpect.spawn { cmd }
  .on_err expectation

parallel 'shelltest', ->
  it 'can check the output of a successful shell command', ->
    assert_exit_status 'echo muffins', 0

  it 'can check the output of an unsuccessful shell command', ->
    assert_exit_status 'false', 1

  describe 'wait_for', ->
    it 'can check stdout with a regex', ->
      regex = /(h[^m]+)([\w ]+?) (s.+?i[^ ])+.+?f(\w+)/
      spawn_and_match 'echo hes got big muffins and shes got big muffins && read', regex
      .then (matches) ->
        assert.equal matches[1], 'hes got big '
        assert.equal matches[2], 'muffins and'
        assert.equal matches[3], 'shes got big'
        assert.equal matches[4], 'fins'

    it 'can check stderr with a regex', ->
      regex = /(h[^m]+)([\w ]+?) (s.+?i[^ ])+.+?f(\w+)/
      spawn_and_match_err '>&2 echo hes got big muffins and shes got big muffins && read', regex
      .then (matches) ->
        assert.equal matches[1], 'hes got big '
        assert.equal matches[2], 'muffins and'
        assert.equal matches[3], 'shes got big'
        assert.equal matches[4], 'fins'

module.exports = {
  spawn_and_match
  assert_exit_status
}
