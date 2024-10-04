Crafty.c 'Enabled',
  init: ->
    @requires 'Color, Mouse'
    @color '#ffffff', 0.0

    @bind 'MouseOver', ->
      @color '#6666b6', 0.2
      return
    @bind 'MouseOut', ->
      @color '#ffffff', 0.0
      return

    return

  disable: ->
    @removeComponent 'Enabled'
    @addComponent 'Disabled'

    return
