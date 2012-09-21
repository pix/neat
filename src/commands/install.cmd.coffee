fs = require 'fs'
{resolve} = require 'path'
Neat = require '../neat'

COFFEE = "#{Neat.neatRoot}/node_modules/.bin/coffee"
{puts, error, info, green, red} = Neat.require "utils/logs"
{run, aliases, describe} = Neat.require "utils/commands"
{'package.json':generate} = Neat.require 'generators'
{render} = Neat.require "utils/templates"
_ = Neat.i18n.getHelper()

install = (pr) ->
  unless pr?
    throw new Error _('neat.commands.no_program', command:'install')

  aliases 'i', 'install',
  describe _('neat.commands.install.description'),
  f = (args..., callback)->
    unless Neat.root?
      throw new Error _("neat.errors.outside_neat", expression: 'neat install')

    fs.readFile 'Nemfile', (err, nemfile) ->
      throw new Error _('neat.commands.install.no_nemfile') if err

      puts "Nemfile found"
      render __filename, (err, source) ->
        throw err if err?

        source = source.replace "###_NPM_DECLARATION_###", nemfile.toString()

        # The produced source code is then executed by `coffee`.
        run COFFEE, ['-e', source], (status) ->
          if status is 0
            info green _('neat.commands.install.install_done')
          else
            error red _('neat.commands.install.install_failed')

          generate 'package.json', ->
            callback?()

module.exports = {install}
