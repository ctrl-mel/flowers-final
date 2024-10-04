# The Grid component allows an element to be located
#  on a grid of tiles
Crafty.c 'Grid',
  init: ->
    @attr
      w: Game.map_grid.tile.width
      h: Game.map_grid.tile.height

    return

  at: (x, y) ->
    if x == undefined and y == undefined
      {
        x: @x / Game.map_grid.tile.width
        y: @y / Game.map_grid.tile.height
      }
    else
      @attr
        x: x * Game.map_grid.tile.width
        y: y * Game.map_grid.tile.height

      this
