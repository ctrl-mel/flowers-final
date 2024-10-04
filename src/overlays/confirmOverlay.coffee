Crafty.c 'ConfirmOverlay',
  init: ->
    @baseZ = 600

    @overlayWidth = 300
    @overlayHeight = 90

    @centerOverlayHorizontally()
    @centerOverlayVertically()

  centerOverlayHorizontally: ->
    @x = (Game.width() - @overlayWidth) / 2

  centerOverlayVertically: ->
    @y = (Game.height() - @overlayHeight) / 2

  showOverlay: ->
    # outside of confirm overlay click handler (has to handle confirm button handling as well)
    that = @
    outOfClickHandler = Crafty.e('2D, DOM, Mouse').attr(
      x: 0
      y: 0
      w: Game.width()
      h: Game.height()
      z: 0
    ).bind 'Click', ->
      that.overlay.destroy()
      outOfClickHandler.destroy()
      return

    @overlay = Crafty.e('2D, DOM').attr(
      x: @x
      y: @y
      w: @overlayWidth
      h: @overlayHeight
      z: @baseZ
    ).css(Game.overlayConfirmCss)

    infoText = Crafty.e('2D, DOM, Text').attr(
      x: @x + 2
      y: @y + 2
      w: @overlayWidth
      h: 50
      z: @baseZ + 20
    ).text(@infoTextContent).textFont(Game.overlayInfoFont).textColor(Game.headlineColor).css(Game.centerCss)

    @overlay.attach infoText

    triggerName = @triggerName
    confirmButton = Crafty.e('DOMButton').attr(
      x: @x + 2
      y: @y + 50
      w: @overlayWidth
      h: 50
      z: @baseZ + 20
    ).text('Confirm').disableTooltip().bind 'Click', ->
      Crafty.trigger triggerName
      that.overlay.destroy()
      outOfClickHandler.destroy()
      return

    @overlay.attach confirmButton
