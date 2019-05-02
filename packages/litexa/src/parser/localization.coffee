class exports.LocalizationContext
  constructor: ->

  pushDialog: (line) ->
    @dialog = @dialog ? []
    @dialog.push line

  pushOption: (key, context) ->
    @options = @options ? {}
    @options[key] = context

  registerVariable: (content) ->
    @variables = @variables ? []
    for v, i in @variables
      return i if v == content
    @variables.push content
    return @variables.length - 1

  hasContent: ->
    return true if @dialog?
    return true if @option?
    return true if @variables?
    return false
