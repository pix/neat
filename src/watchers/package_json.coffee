Q = require 'q'
Neat = require '../neat'
WatchPlugin = Neat.require 'tasks/watch/watch_plugin'
commands = Neat.require 'utils/commands'

class PackageJson extends WatchPlugin
  pathChanged: (path, action) -> =>
    @deferred = Q.defer()
    @process = commands.run 'neat', ['generate', 'package.json'], (status) =>
      @deferred.resolve status
    @deferred.promise

  kill: (signal) ->
    @process.kill signal
    @deferred.resolve 1

  isPending: -> @deferred? and @deferred.promise.isPending()

module.exports.package_json = PackageJson
