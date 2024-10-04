Crafty.c 'Disabled', init: ->
  @requires 'Color, Mouse, Delay'
  @color '#ff0000', 0.5

  @bind 'MouseOut', ->
    @color '#ff0000', 0.5
    return

  @delay (->
    @removeComponent 'Disabled'
    @addComponent 'Enabled'
    return
  ), 20000, 0

  return
