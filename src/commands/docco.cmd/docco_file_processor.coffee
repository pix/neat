fs = require 'fs'
{resolve} = require 'path'

Neat = require '../../neat'
DoccoPreProcessor = require './docco_pre_processor'
DoccoTitleProcessor = require './docco_title_processor'
SHOWDOWN = "#{Neat.neatRoot}/node_modules/docco/vendor/showdown"

{puts, error, missing} = Neat.require 'utils/logs'
{render} = Neat.require 'utils/templates'
{parallel} = Neat.require 'async'
_ = Neat.i18n.getHelper()

try
  {parse} = require 'docco'
  {Showdown:showdown} = require SHOWDOWN
catch e
  return error _('neat.commands.docco.missing_module',
                  missing: missing 'docco')

try
  {highlight} = require 'highlight.js'
catch e
  return error _('neat.commands.docco.missing_module',
                  missing: missing 'docco')

class DoccoFileProcessor

  TPL_PATH = resolve __dirname.replace('.cmd',''), '_page'
  TPL_TOC = resolve __dirname.replace('.cmd',''), '_toc'

  @asCommand = (f, h, n) -> (cb) -> new DoccoFileProcessor(f, h, n).process cb

  constructor: (@file, @header, @nav) ->

  highlightFile: (path, sections, callback) ->
    for o in sections
      {code_text, docs_text} = o
      res = highlight('coffeescript', code_text)
      o.code_html = "<pre>#{res.value}</pre>"
      o.docs_html = showdown.makeHtml docs_text

    titles = []
    presCmd = []
    titlesCmd = []
    for section in sections
      presCmd.push DoccoPreProcessor.asCommand path, section
      titlesCmd.push DoccoTitleProcessor.asCommand path, section, titles

    parallel presCmd, =>
      parallel titlesCmd, =>
        render TPL_TOC, {titles}, (err, toc) =>
          throw err if err?
          callback toc

  process: (callback) ->
    fs.readFile @file.path, (err, code) =>
      throw err if err?

      sections = parse @file.path, code.toString()
      @highlightFile @file.path, sections, (toc) =>

        context = {sections, @header, @nav, @file}
        render TPL_PATH, context, (err, page) =>
          throw err if err?

          page = page.replace /@toc/g, toc

          fs.writeFile @file.outputPath, page, (err) =>
            throw err if err?
            puts _('neat.commands.docco.file_generated',
                    file: @file.relativePath.yellow), 1
            callback?()

module.exports = DoccoFileProcessor
