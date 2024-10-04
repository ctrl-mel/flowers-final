###*
# Path class that offers adding points to the path and utilities like generate start and finish
# @param config
###
class Path
  constructor: (config) ->
    @width = config.width
    @height = config.height
    @generateStartInColumn 0
    @generateFinishInColumn config.width - 1

    # min and max length are not fix values, rather a guideline (actual min and max can vary by 10%)
    @pathMinLength = config.pathMinLength or 0
    @pathMaxLength = config.pathMaxLength or Math.MAX_VALUE

    @top = 1
    @left = 1
    @bottom = @height - 2
    @right = @width - 2

    @path = @generateArrayWithFalseValues @width, @height
    @occupied = @generateArrayWithFalseValues @width, @height

    @pointPath = []

    @pathLength = 0

    return


  generateArrayWithFalseValues: (width, height) ->
    array = new Array(width)
    x = 0
    while x < width
      array[x] = new Array(height)
      y = 0
      while y < height
        array[x][y] = false
        y++
      x++

    array


  pointsEqual: (point1, point2) ->
    point1.x == point2.x and point1.y == point2.y


  generateStartInColumn:  (column) ->
    @start =
      x: column
      y: 1 + Math.floor(Math.random() * (@height - 2))

    return


  generateStartOnRow:  (row) ->
    @start =
      x: 1 + Math.floor(Math.random() * (@width - 2))
      y: row

    return


  generateFinishInColumn:  (column) ->
    @finish =
      x: column
      y: 1 + Math.floor(Math.random() * (@height - 2))

    return


  generateFinishOnRow:  (row) ->
    @finish =
      x: @start.x + Math.floor(Math.random() * (@width - (@start.x) - 1))
      y: row

    return


  setStart: (x, y) ->
    @start =
      x: x
      y: y

    return


  setFinish: (x, y) ->
    @finish =
      x: x
      y: y

    return


  copy:  (path) ->
    @start = path.start
    @finish = path.finish
    @width = path.width
    @height = path.height

    @pathMinLength = path.pathMinLength
    @pathMaxLength = path.pathMaxLength

    # FIXME better make a copy of the arrays
    @path = path.path
    @occupied = path.occupied
    @pointPath = path.pointPath

    return


  addToPath:  (point) ->
    if point.x < 0 or point.x > @width - 1
      console.log 'Illegal point!! at x=' + point.x + ';y=' + point.y
      return

    @path[point.x][point.y] = true
    @occupied[point.x][point.y] = true
    @pointPath.push
      x: point.x
      y: point.y

    return


  addObstacle:  (point) ->
    if point.x < 0 or point.x > @width - 1
      console.log 'Illegal point for addObstacle!! at x=' + point.x + ';y=' + point.y
      return

    @occupied[point.x][point.y] = true

    return


  remove:  (point) ->
    if point.x < 0 or point.x > @width - 1
      console.log 'Illegal point!! at x=' + point.x + ';y=' + point.y
      return

    @path[point.x][point.y] = false
    @occupied[point.x][point.y] = false

    @pathLength--

    i = @pointPath.length - 1
    while i >= 0
      if @pointPath[i].x == point.x and @pointPath[i].y == point.y
        @pointPath.splice i, 1
        console.log 'Removed ' + point.x + '/' + point.y + ' from pointPath'
        return
      i--

    console.log 'Could not find point at ' + point.x + ', ' + point.y + ' to remove.'

    return


  isOnEdge:  (x, y) ->
    if x == @start.x and y == @start.y
      return false
    if x == @finish.x and y == @finish.y
      return false

    x == 0 or x == @width - 1 or y == 0 or y == @height - 1


  isOccupied:  (x, y) ->
    if typeof x == 'number' and typeof y == 'number' and x < @occupied.length and x >= 0
      @occupied[x][y]
    else
      false


  isOnPath:  (x, y) ->
    if typeof x == 'number' and typeof y == 'number' and x < @path.length and x >= 0
      @path[x][y]
    else
      false


  getInDirection:  (point, direction) ->
    if point.x < 0 or point.x > @width - 1
      console.log 'Illegal point!! at x=' + point.x + ';y=' + point.y
      return

    # copy point so we don't change the input
    point =
      x: point.x
      y: point.y

    if direction == Direction.DOWN
      point.y++
    else if direction == Direction.RIGHT
      point.x++
    else if direction == Direction.UP
      point.y--
    else if direction == Direction.LEFT
      point.x--
    else
      throw 'unknown direction'

    point


  createPathElement:  (direction, ignoreBorders) ->
    if direction == Direction.DOWN and (@current.y < @bottom or ignoreBorders)
      @current.y++
      @addToPath @current
      @pathLength++

      true
    else if direction == Direction.RIGHT and (@current.x < @right or ignoreBorders)
      @current.x++
      @addToPath @current
      @pathLength++

      true
    else if direction == Direction.UP and (@current.y > @top or ignoreBorders)
      @current.y--
      @addToPath @current
      @pathLength++

      true
    else if direction == Direction.LEFT and (@current.x > @left or ignoreBorders)
      @current.x--
      @addToPath @current
      @pathLength++

      true
    else
      false


  createPathElementIgnoreBorders:  (direction) ->
    @createPathElement direction, true

    return


  continuePathTo:  (x, y, ignoreBorders) ->
    directionX = undefined
    directionY = undefined
    startTime = (new Date).getTime()

    if x < @current.x
      directionX = Direction.LEFT
    else
      directionX = Direction.RIGHT

    if y < @current.y
      directionY = Direction.UP
    else
      directionY = Direction.DOWN

    while x != @current.x or y != @current.y
      # timeout handling
      if (new Date).getTime() - startTime > 5000
        console.log 'Timeout after 5 seconds!! total=' + @pathLength
        console.log 'current.x=' + @current.x + '; current.y=' + @current.y
        console.log 'start.x=' + @start.x + '; start.y=' + @start.y
        console.log 'finish.x=' + @finish.x + '; finish.y=' + @finish.y
        break

      if x != @current.x
        @createPathElement directionX, ignoreBorders

      if y != @current.y
        @createPathElement directionY, ignoreBorders

    return


  getAsList:  ->
    if @pointPath
      return @pointPath


# make this class known outside
window.Path = Path
