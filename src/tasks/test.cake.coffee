path = require 'path'
Neat = require '../neat'
{queue} = Neat.require 'async'
{neatTask} = Neat.require 'utils/commands'
{namespace} = Neat.require 'utils/exports'
{error, info, green, red, yellow, puts} = Neat.require 'utils/logs'
_ = Neat.i18n.getHelper()

test = (k,f,n,d) -> (callback) -> f n, d, -> callback?()

beforeTests = (test) -> (callback) ->
  Neat.task('compile') (status) ->
    if status is 0 then test callback else callback?()

runTests = (name, dir) -> (callback) ->
  actions = (test k,f,name,dir for k,f of Neat.config.engines.tests)
  queue actions, -> callback?()

index = neatTask
  name:'test'
  description: _('neat.tasks.test.description')
  environment: 'test'
  action: beforeTests (callback) ->
    runTests('unit', 'test/units') (status) ->
      runTests('functional', 'test/functionals') (status) ->
        info green _('neat.tasks.test.tests_done')
        callback?()

unit = neatTask
  name:'test:unit'
  description: _('neat.tasks.test.unit_description')
  environment: 'test'
  action: beforeTests (callback) ->
    runTests('unit', 'test/units') ->
      info green _('neat.tasks.test.tests_done')
      callback?()

functional = neatTask
  name:'test:functional'
  description: _('neat.tasks.test.functional_description')
  environment: 'test'
  action: beforeTests (callback) ->
    runTests('functional', 'test/functionals') ->
      info green _('neat.tasks.test.tests_done')
      callback?()

module.exports = namespace 'test', {index, unit, functional}
