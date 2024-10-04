Crafty.c 'DOMButton', init: ->
  @requires 'Button, DOM'
  @css Game.buttonCss
  originalText = @text

  @text = (text) ->
    if typeof text == 'undefined' or text == null
      return @_text

    originalText.call this, text
    @_element.innerHTML = @_text
    this

  @enable = ->
    @attr buttonEnabled: true
    @removeComponent 'disabledButton'
    this

  @disable = ->
    @attr buttonEnabled: false
    @addComponent 'disabledButton'
    this

  return
