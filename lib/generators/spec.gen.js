// Generated by CoffeeScript 1.3.3
(function() {
  var describe, fs, namedEntity, spec, usages, _ref;

  fs = require('fs');

  _ref = require('../utils/commands'), describe = _ref.describe, usages = _ref.usages;

  namedEntity = require('../utils/generators').namedEntity;

  usages('neat generate spec [name]', describe('Generates a [name] spec in the specs directory', spec = namedEntity(__filename, 'test/spec', 'spec.coffee')));

  module.exports = {
    spec: spec
  };

}).call(this);