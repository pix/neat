require '../../../test_helper'
Neat = require '../../../../lib/neat'
{run} = require '../../../../lib/utils/commands'
{print} = require 'util'

options = {}
  # stderr: (data)-> print data
  # stdout: (data)-> print data

describe 'when outside a project', ->
  beforeEach ->
    process.chdir FIXTURES_ROOT
    addFileMatchers this

  describe 'running `neat generate config:lint`', ->

    it "should return a status of 1 and don't generate anything", ->
      ended = false
      runs ->
        args = [NEAT_BIN, 'generate', 'config:lint']
        run 'node', args, options, (status) ->
          expect(status).toBe(1)
          expect("#{FIXTURES_ROOT}/config/tasks/lint.json").not.toExist()
          ended = true

      waitsFor progress(-> ended), 'Timed out', 10000

withProject 'foo', ->
  describe 'running `neat generate config:lint`', ->
    args = [
      NEAT_BIN,
      'generate',
      'config:lint',
    ]
    it 'should generate a lint.json file at the config/tasks dir', (done) ->
      run 'node', args, (status) ->
        path = inProject "config/tasks/lint.json"
        expect(path).toExist()
        done()
