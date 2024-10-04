class Direction
  constructor: (@value) ->

  # constants
  @DOWN: 0
  @RIGHT: 1
  @UP: 2
  @LEFT: 3

  turnLeft: ->
    @value = (@value + 1) % 4

  turnRight: ->
    @value = (@value + 3) % 4


# make this class known outside
window.Direction = Direction
