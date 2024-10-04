Crafty.c 'Tooltip',
  init: ->
    @requires 'Mouse'
    @tooltipText = 'Tooltip-Text here'
    @_tooltip = null
    @tooltipWidth = 300
    @tooltipHeight = 50
    @baseZ = 500

    @bind 'MouseOver', @createTooltip
    @bind 'MouseOut', @destroyTooltip

    return

  disableTooltip: ->
    @unbind 'MouseOver', @createTooltip
    @unbind 'MouseOut', @destroyTooltip

  createTooltip: ->
    x = Math.min(Game.width() - (@tooltipWidth) - 10, Math.max(0, @x + (@w - (@tooltipWidth)) / 2))
    y = Math.max(0, @y - (@tooltipHeight) - 10)

    if @y < @h + @tooltipHeight
      y = @y + @h

    @_tooltip = Crafty.e('2D, DOM, Mouse').attr(
      x: x
      y: y
      w: @tooltipWidth
      h: @tooltipHeight
      z: @baseZ).css(Game.generalTooltipCss)

    tooltipText = Crafty.e('2D, DOM, Text').attr(
      x: x + 2
      y: y + 2
      w: @tooltipWidth
      h: @tooltipHeight
      z: @baseZ + 20).text(@tooltipText).textFont(Game.generalTooltipFont).textColor(Game.textColor).css(Game.centerCss)

    @_tooltip.attach tooltipText
    @attach @_tooltip

    return

  destroyTooltip: ->
    @_tooltip.destroy()
    return

  tooltip: (text) ->
    @tooltipText = text
    if @_tooltip and @_tooltip._children.length > 0
      @_tooltip._children[0].text text

    this
