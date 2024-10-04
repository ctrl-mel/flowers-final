# TODO convert to generator class
Path::generateLabyrinth = ->
  @current =
    x: @start.x
    y: @start.y
  @addToPath @current
  @pathLength = 1

  @left = 3
  @top = 3
  @right = @width - 4
  @bottom = @height - 4

  stateMachine = new StateMachine
  startTime = (new Date).getTime()
  retryCount = 0
  stateMachine.setStart 'start'

  if @current.x == 0
    stateMachine.put 'start', undefined, 'goright', 1
  else if @current.y == 0
    stateMachine.put 'start', undefined, 'godown', 0
  else if @current.y == @height - 1
    stateMachine.put 'start', undefined, 'goup', 2
  else if @current.x == @width - 1
    stateMachine.put 'start', undefined, 'goleft', 3

  stateMachine.put 'goright', Direction.DOWN, 'godown_or_right'
  stateMachine.put 'goright', Direction.RIGHT, 'goright'
  stateMachine.put 'goright', Direction.UP, 'goup_or_right'

  stateMachine.put 'godown', Direction.RIGHT, 'godown_or_right'
  stateMachine.put 'godown', Direction.DOWN, 'godown'
  stateMachine.put 'godown', Direction.LEFT, 'godown_or_left'

  stateMachine.put 'goup', Direction.RIGHT, 'goup_or_right'
  stateMachine.put 'goup', Direction.UP, 'goup'
  stateMachine.put 'goup', Direction.LEFT, 'goup_or_left'

  stateMachine.put 'goleft', Direction.DOWN, 'godown_or_left'
  stateMachine.put 'goleft', Direction.LEFT, 'goleft'
  stateMachine.put 'goleft', Direction.UP, 'goup_or_left'

  stateMachine.put 'godown_or_left', Direction.DOWN, 'godown'
  stateMachine.put 'godown_or_left', Direction.LEFT, 'goleft'

  stateMachine.put 'godown_or_right', Direction.DOWN, 'godown'
  stateMachine.put 'godown_or_right', Direction.RIGHT, 'goright'

  stateMachine.put 'goup_or_left', Direction.UP, 'goup'
  stateMachine.put 'goup_or_left', Direction.LEFT, 'goleft'

  stateMachine.put 'goup_or_right', Direction.RIGHT, 'goright'
  stateMachine.put 'goup_or_right', Direction.UP, 'goup'

  while @pathLength < 0.95 * @pathMaxLength and not @pointsEqual(@getInDirection(@current, Direction.UP), @finish) and not @pointsEqual(@getInDirection(@current, Direction.RIGHT), @finish) and not @pointsEqual(@getInDirection(@current, Direction.DOWN), @finish) and not @pointsEqual(@getInDirection(@current, Direction.LEFT), @finish)
    # timeout handling
    if (new Date).getTime() - startTime > 5000
      console.log 'Timeout after 5 seconds!! total=' + @pathLength
      console.log 'current.x=' + @current.x + '; current.y=' + @current.y
      console.log 'start.x=' + @start.x + '; start.y=' + @start.y
      console.log 'finish.x=' + @finish.x + '; finish.y=' + @finish.y
      break

    direction = Math.floor(Math.random() * 4)
    point1 = @getInDirection(@current, direction)
    point2 = @getInDirection(point1, direction)
    point3 = @getInDirection(point1, (direction + 1) % 4)
    point4 = @getInDirection(point1, (direction + 3) % 4)

    # backtracking
    if retryCount > 15
      @remove @current
      @addObstacle @current
      stateMachine.resetBy 1

      # we search for the next adjacent path tile and move there.
      # this works because in this part we don't let the path cross itself.
      if @isOnPath(@current.x - 1, @current.y)
        @current.x--
      else if @isOnPath(@current.x + 1, @current.y)
        @current.x++
      else if @isOnPath(@current.x, @current.y - 1)
        @current.y--
      else if @isOnPath(@current.x, @current.y + 1)
        @current.y++

      retryCount = 0
      continue

    retryCount++

    if @isOccupied(point1.x, point1.y) or @isOnPath(point2.x, point2.y) or @isOnPath(point3.x, point3.y) or @isOnPath(point4.x, point4.y)
      continue

    if @pathLength >= 0.9 * @pathMinLength
      @left = 1
      @top = 1
      @right = @width - 2
      @bottom = @height - 2

      if direction == Direction.RIGHT and @finish.x == 0
        continue

    result = stateMachine.transition(direction)
    created = undefined
    if result != undefined and result.output != undefined
      created = @createPathElement(result.output)
    else if result != undefined
      created = @createPathElement(direction)

    if created
      retryCount = 0

  # continue to finish
  finishX = Math.max(@left, Math.min(@finish.x, @right))
  finishY = Math.max(@top, Math.min(@finish.y, @bottom))

  @continuePathTo finishX, finishY
  @continuePathTo @finish.x, @finish.y, true

  if @pathLength >= @pathMinLength
    console.log 'Finished creating random labyrinth path \\o/ (length=' + @pathLength + ')'
  else
    # reset everything
    @top = 1
    @left = 1
    @bottom = @height - 2
    @right = @width - 2

    @path = @generateArrayWithFalseValues @width, @height
    @occupied = @generateArrayWithFalseValues @width, @height

    @pointPath = []

    @generateLabyrinth()

  return
