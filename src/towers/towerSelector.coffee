Crafty.c 'TowerSelector',
  init: ->
    @requires 'DOMButton, Grid, Keyboard'

    @attr
      x: 0
      y: Game.height() - (Game.map_grid.tile.height)
      z: 100
    @textFont Game.towerSelectorFont

    return

  forTower: (towerName) ->
    @targetTower = towerName

    @bind 'EnterFrame', ->
      if @oldValue != Game.towers[towerName]
        @text Game.towers[towerName]
      return

    @bind 'TowerCreated', ->
      @text Game.towers[towerName]
      return

    if Game.selectedTower == @targetTower
      @textColor Game.highlightColor
    else
      @textColor Game.textColor

    @bind 'TowerChanged', ->
      if Game.selectedTower == @targetTower
        @textColor Game.highlightColor
      else
        @textColor Game.textColor
      return

    @bind 'Click', ->
      Game.selectedTower = towerName
      Crafty.trigger 'TowerChanged'
      return

    this

  withHotkey: (hotkey) ->
    @bind 'KeyDown', ->
      if @isDown(hotkey)
        Game.selectedTower = @targetTower
        Crafty.trigger 'TowerChanged'
      return
    this
