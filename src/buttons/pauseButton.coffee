Crafty.c 'PauseButton',
  init: ->
    @requires 'DOMButton, Grid, Keyboard'

    @pauseOverlay = Crafty.e 'PauseOverlay'

    @text('Pause').textFont(Game.waveFont).at(13, Game.map_grid.height - 1).attr(
      w: 100
      h: 50
    ).tooltip('Pause or unpause the game (Hotkey: P)').bind('Click', @pauseUnpause).bind('KeyDown', @pauseUnpause)

  pauseUnpause: ->
    wasPaused = Crafty.isPaused()

    Crafty.pause()

    if Crafty.isPaused()
      @pauseOverlay.open()
    else
      @pauseOverlay.close()
