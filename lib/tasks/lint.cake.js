// Generated by CoffeeScript 1.3.3
(function() {
  var COFFEE_LINT, Neat, asyncErrorTrap, error, find, findSiblingFile, green, info, missing, neatTask, path, print, puts, queue, red, run, yellow, _ref, _ref1, _ref2;

  path = require('path');

  Neat = require('../neat');

  _ref = Neat.require('utils/commands'), run = _ref.run, neatTask = _ref.neatTask, asyncErrorTrap = _ref.asyncErrorTrap;

  _ref1 = Neat.require('utils/logs'), error = _ref1.error, info = _ref1.info, green = _ref1.green, red = _ref1.red, puts = _ref1.puts, print = _ref1.print, yellow = _ref1.yellow, missing = _ref1.missing;

  _ref2 = Neat.require('utils/files'), find = _ref2.find, findSiblingFile = _ref2.findSiblingFile;

  queue = Neat.require('async').queue;

  COFFEE_LINT = "" + Neat.neatRoot + "/node_modules/.bin/coffeelint";

  exports['lint'] = neatTask({
    name: 'lint',
    description: 'Lint the sources with coffee-lint',
    environment: 'default',
    action: function(callback) {
      var dir;
      if (!path.existsSync(COFFEE_LINT)) {
        error("" + (red("Can't find coffeelint module")) + "\n\nRun " + (yellow('neat install')) + " to install the dependencies.");
        return typeof callback === "function" ? callback() : void 0;
      }
      path = __filename;
      dir = 'lib/config';
      return findSiblingFile(path, Neat.paths, dir, 'json', asyncErrorTrap(function(conf) {
        var errors, files, lint, paths;
        if (conf == null) {
          error(missing("lint configuration"));
          return typeof callback === "function" ? callback() : void 0;
        }
        errors = [];
        lint = function(file) {
          return function(callback) {
            var logs, opts, params;
            params = ["-f", conf, file];
            logs = [];
            opts = {
              noStdout: true,
              stderr: function(data) {
                return logs.push(function() {
                  return print(data);
                });
              }
            };
            return run('coffeelint', params, opts, function(status) {
              if (status === 0) {
                print(green('.'));
              } else {
                print(red('F'));
                errors.push(function() {
                  var log, _i, _len, _results;
                  puts(red("" + (file.replace("" + Neat.root + "/", '')) + " is not ok"));
                  _results = [];
                  for (_i = 0, _len = logs.length; _i < _len; _i++) {
                    log = logs[_i];
                    _results.push(log());
                  }
                  return _results;
                });
              }
              return typeof callback === "function" ? callback() : void 0;
            });
          };
        };
        paths = ["" + Neat.root + "/src", "" + Neat.root + "/test"];
        return files = find('coffee', paths, function(err, files) {
          var file;
          return queue((function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = files.length; _i < _len; _i++) {
              file = files[_i];
              _results.push(lint(file));
            }
            return _results;
          })(), function() {
            var _i, _len;
            puts('');
            if (errors.length === 0) {
              info(green('All files linted'));
            } else {
              for (_i = 0, _len = errors.length; _i < _len; _i++) {
                error = errors[_i];
                error();
              }
            }
            return typeof callback === "function" ? callback() : void 0;
          });
        });
      }));
    }
  });

}).call(this);