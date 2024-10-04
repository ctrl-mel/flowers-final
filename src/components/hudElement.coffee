Crafty.c 'HudElement',
  init: ->
    @requires '2D, DOM, Grid, Text'
    @attr
      x: 0
      y: 0
      w: Game.width()
    @textFont Game.hudFont
    @textColor Game.textColor

    return

  observe: (prefix, observable, suffix) ->
    if suffix == undefined
      suffix = ''

    @observable = observable

    @bind 'EnterFrame', ->
      newValue = undefined

      if typeof @observable == 'function'
        newValue = @observable.call()
      else
        newValue = Game[@observable]

      if @oldValue != newValue
        @trigger 'ValueChanged', newValue
        @oldValue = newValue
      return

    @bind 'ValueChanged', (data) ->
      @text prefix + ': ' + data + suffix
      return

    this

  alertIfBelow: (threshold) ->
    @bind 'ValueChanged', (data) ->
      if data < threshold
        @textColor Game.alertColor
      else
        @textColor Game.textColor
      return

    this

  highlight: ->
    @bind 'ValueChanged', (data) ->
      if data > 0
        @textColor Game.highlightColor
      else
        @textColor Game.textColor
      return

    this
