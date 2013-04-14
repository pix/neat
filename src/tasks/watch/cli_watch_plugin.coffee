Neat = require '../../neat'
WatchPlugin = Neat.require 'tasks/watch/watch_plugin'

class CLIWatchPlugin extends WatchPlugin
  kill: (signal) ->
    @process.kill signal

  isPending: -> @deferred? and @deferred.promise.isPending()

module.exports = CLIWatchPlugin
