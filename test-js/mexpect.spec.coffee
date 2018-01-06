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

parallel 'mexpect', ->
  it 'can wait for a string', (done) ->
    mexpect.spawn { cmd: 'echo muffins' }
    .on_data('muffins').then (match) ->
      assert.equal 'muffins', match
      done()

  it 'can wait for a regex', (done) ->
    mexpect.spawn { cmd: 'echo muffins' }
    .on_data(/.f.i/).then (match) ->
      assert.equal 'uffi', match
      done()

  it 'blocks streams until an expectation matches (does not skip output)', ->
    mproc = mexpect.spawn { cmd: 'echo muffins; echo sugary' }
    mproc.on_data(/muffins/).then ([match]) ->
      assert.equal 'muffins', match
      mproc.on_data(/sugary/).then (match) ->
        assert.equal match, 'sugary'

  it 'can wait for an array', ->
    cmd = 'a quick brown fox jumps over the lazy dog'.split(' ').map (s) ->
      "echo #{s};"
    .join(' ')

    mexpect.spawn { cmd }
    .on_data(['quick', 'brown', /.(h)[^ ]+/, 'dog']).then (match) ->
      assert.equal 'quick', match[0]
      assert.equal 'brown', match[1]
      assert.equal 'the',   match[2]
      assert.equal 'h',     match[3]
      assert.equal 'dog',   match[4]

  it 'can wait for nothing', ->
    mexpect.spawn { cmd: 'echo testing the abyss' }
    .on_data()

  it 'can attach a wait_for later', ->
    mproc = mexpect.spawn { cmd: 'echo Hideeho' }

    new Promise (resolve, reject) ->
      setTimeout ->
        mproc.on_data /Hi/
        .then ->
          resolve()
      , 50

  it 'can take some env variables', ->
    mproc = mexpect.spawn
      cmd: 'env'
      env: TEST_1_2: 'Ahoy!'

    mproc.on_data /TEST_1_2=Ahoy!/

module.exports = {
  spawn_and_match
  assert_exit_status
}
