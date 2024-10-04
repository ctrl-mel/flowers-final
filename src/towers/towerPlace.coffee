Crafty.c 'TowerPlace', init: ->
  @requires '2D, Canvas, Grid, Delay, Mouse, Image, Color, Tooltip'
  @image('assets/images/transparent.png').color '#ffffff', 0.0

  @bind 'MouseOver', ->
    @color '#b66666', 0.2
    return
  @bind 'MouseOut', ->
    @color '#ffffff', 0.0
    @previousMouseUp = false
    return

  if Crafty.mobile
    @bind 'MouseUp', (e) ->
      if @previousMouseUp
        @trigger 'Click', e
      else
        @previousMouseUp = true
      return

  @tooltip 'Build a new ' + Game.selectedTower + ' here for ' + Game.towers[Game.selectedTower] + ' gold'

  @bind 'TowerCreated', ->
    @delay (->
      @tooltip 'Build a new ' + Game.selectedTower + ' here for ' + Game.towers[Game.selectedTower] + ' gold'
      return
    ), 500, 0
    return

  @bind 'TowerChanged', ->
    @tooltip 'Build a new ' + Game.selectedTower + ' here for ' + Game.towers[Game.selectedTower] + ' gold'
    return

  @bind 'Click', ->
    if Game.money >= Game.towers[Game.selectedTower]
      tower = Crafty.e(Game.selectedTower).at(@at().x, @at().y)
      Game.money -= Game.towers[Game.selectedTower]
      Crafty.trigger 'TowerCreated', tower
      Crafty('Sidebar').openFor tower
      @destroy()
    return

  return
