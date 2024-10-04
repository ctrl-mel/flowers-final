Crafty.c 'LevelSelector',
  init: ->
    @requires 'DOMButton, TweenXY'
    return

  level: (level) ->
    @text 'Level ' + level
    @addComponent 'preview_level' + level
    @bind 'Click', ->
      Crafty.scene 'InitializeLevel' + level
      return

    this
