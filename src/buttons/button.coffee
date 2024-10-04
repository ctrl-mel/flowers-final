# The button component styles a (text) component as a button
Crafty.c 'Button',
  init: ->
    @requires '2D, Text, Mouse, Tooltip'

    # override textColor method to save used text colors
    @overrideTextColorFunction()
    @_highlightColor = Game.highlightColor

    @textFont Game.generalButtonFont
    @enable()

    if Crafty.mobile
      @bind 'MouseUp', (e) ->
        if @_previousMouseUp
          @trigger 'Click', e
        else
          @_previousMouseUp = true
        return

    return

  overrideTextColorFunction: ->
    @_previousColors = []
    @_previousTextColor = @textColor

    @textColor = (newColor) ->
      @_previousTextColor.call this, newColor
      @_previousColors.unshift newColor
      if @_previousColors.length > 5
        @_previousColors.pop()
      this

    return

  mouseOverHandler: ->
    @_previousTextColor.call this, @_highlightColor

    return

  mouseOutHandler: ->
    @textColor @_previousColors[0]
    @_previousMouseUp = false

    return

  enable: ->
    # highlight on mouse over, but don't save the highlight color as "used text color"
    @textColor Game.textColor
    @bind 'MouseOver', @mouseOverHandler
    @bind 'MouseOut', @mouseOutHandler
    @attr buttonEnabled: true

    this

  disable: ->
    @unbind 'MouseOver', @mouseOverHandler
    @unbind 'MouseOut', @mouseOutHandler
    @textColor Game.disabledColor
    @attr buttonEnabled: false

    this

  highlightColor: (color) ->
    @_highlightColor = color

    this

  withImage: (imageUrl) ->
    image = Crafty.e('2D, Image, ' + (if @has('Canvas') then 'Canvas' else 'DOM'))
    image.image(imageUrl).attr
      x: @x
      y: @y
    @attach image

    this

  withSprite: (spriteId) ->
    @addComponent spriteId

    this
