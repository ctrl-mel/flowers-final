Crafty.c 'RestartButton', init: ->
  @requires 'DOMButton'

  @text 'Start again?'
  @tooltip 'Clicking this button starts another game'

  @attr
    x: 0
    y: Game.height() - 100
    w: Game.width()
    h: 50
  @textFont Game.restartFont
  @textColor Game.restartColor

  @bind 'Click', ->
    console.log 'Restaaaaaart'
    if Crafty.isPaused()
      Crafty.pause()
    Crafty.scene 'Difficulty'
    return

  return
