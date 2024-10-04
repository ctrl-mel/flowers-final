Crafty.c 'PauseOverlay',
  init: ->
    @requires 'Overlay'

    @overlayWidth = 100
    @overlayHeight = 40

    @centerOverlayHorizontally()
    @centerOverlayVertically()

    @overlay = Crafty.e('2D, DOM, Text').attr(
      x: @x
      y: @y
      w: @overlayWidth
      h: @overlayHeight
      z: @baseZ
    ).text('Paused').textFont(Game.pauseFont).textColor(Game.textColor).css(Game.overlayCss)

    @close()

  open: ->
    @overlay.css(Game.shownCss)

  close: ->
    @overlay.css(Game.hiddenCss)
