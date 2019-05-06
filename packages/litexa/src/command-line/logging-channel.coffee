
###

 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * Copyright 2019 Amazon.com (http://amazon.com/), Inc. or its affiliates. All Rights Reserved.
 * These materials are licensed as "Restricted Program Materials" under the Program Materials
 * License Agreement (the "Agreement") in connection with the Amazon Alexa voice service.
 * The Agreement is available at https://developer.amazon.com/public/support/pml.html.
 * See the Agreement for the specific terms and conditions of the Agreement. Capitalized
 * terms not defined in this file have the meanings given to them in the Agreement.
 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

###


chalk = require 'chalk'
path = require 'path'
fs = require 'fs'

class LoggingChannel
  constructor: (@name, @outputStream, @filename, @verboseOutput) ->
    @outputStream = @outputStream ? console
    @prefixName = "[#{@name}] "
    @lastConsoleTime = new Date
    @lastFileTime = new Date
    @startTime = new Date
    if @filename
      fs.writeFileSync @filename, '', 'utf8'
      @file = (line) ->
        fs.appendFile @filename, line + '\n', 'utf8', (err) -> # don't care

  output: (format, line, skipOutput) ->
    now = new Date

    unless skipOutput
      deltaTime = now - @lastConsoleTime
      @lastConsoleTime = now
      if format?
        @outputStream.log format @prefixName + "+#{deltaTime}ms " + line
      else
        @outputStream.log @prefixName + "+#{deltaTime}ms " + line

    if @file?
      deltaTime = now - @lastFileTime
      @lastFileTime = now
      @file "+#{deltaTime}ms " + line

  log: (line) ->
    @output null, line

  important: (line) ->
    @output chalk.inverse, line

  verbose: (line, obj) ->
    if obj
      @output chalk.gray, "#{line}: #{JSON.stringify(obj, null, 2)}", (not @verboseOutput)
    else
      @output chalk.gray, line, (not @verboseOutput)

  error: (line) ->
    @output chalk.red, line

  warning: (line) ->
    @output chalk.red, line

  derive: (newName) ->
    new LoggingChannel newName, @outputStream, @filename, @verboseOutput

  runningTime: ->
    new Date - @startTime


module.exports = LoggingChannel
