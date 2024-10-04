Game.start = ->
  Crafty.init Game.width(), Game.height()
  Crafty.background Game.startBackgroundColor
  Game.actualFPS = Crafty.e('ActualFPS')

  Crafty.scene 'Loading'

  return
