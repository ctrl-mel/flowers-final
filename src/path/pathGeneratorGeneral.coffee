# TODO convert to generator class
Path::generatePath = ->
  @current =
    x: @start.x
    y: @start.y

  @horizontal = @start.x == 0
  @generateNextPart()

  return


Path::generatePartInRandomDirection = (lastDir, preLastDir) ->
  # go up? or right? or down?
  # but we never go back (been down one time, been down two times, never going back agaaain ^^)
  direction = Math.floor(Math.random() * 3)
  toFinishAttr = if @horizontal then 'x' else 'y'
  varAttr = if @horizontal then 'y' else 'x'
  boundary1 = if @horizontal then 'width' else 'height'

  # TODO transform this switch statement into using a state machine
  switch direction
    when 0
      if (lastDir == null or lastDir == 0 or lastDir == 1) and (preLastDir == null or preLastDir == 0 or preLastDir == 1) and (@current[toFinishAttr] < @[boundary1] - 3 or @finish[varAttr] < @current[varAttr]) and (@pathLength <= @pathMaxLength or @finish[varAttr] < @current[varAttr])
        if @createPathElement((if @horizontal then Direction.UP else Direction.LEFT))
          @generateNextPart direction, lastDir
          return false
    when 1
      if @current[toFinishAttr] < @[boundary1] / 3 or @pathLength >= @pathMinLength or Math.random() < 0.05
        if @createPathElement((if @horizontal then Direction.RIGHT else Direction.DOWN))
          @generateNextPart direction, lastDir
          return false
    when 2
      if (lastDir == null or lastDir == 2 or lastDir == 1) and (preLastDir == null or preLastDir == 2 or preLastDir == 1) and (@current[toFinishAttr] < @[boundary1] - 3 or @finish[varAttr] > @current[varAttr]) and (@pathLength <= @pathMaxLength or @finish[varAttr] > @current[varAttr])
        if @createPathElement((if @horizontal then Direction.DOWN else Direction.RIGHT))
          @generateNextPart direction, lastDir
          return false

  true


Path::generateNextPart = (lastDir, preLastDir) ->
  needToFindNext = true
  startTime = (new Date).getTime()
  toFinishAttr = if @horizontal then 'x' else 'y'
  varAttr = if @horizontal then 'y' else 'x'

  # start: go right
  if @current.x == @start.x and @current.y == @start.y
    console.log 'Started generating path ' + (if @horizontal then 'horizontally' else 'vertically')
    @addToPath @current
    @pathLength = 1
    @createPathElement if @horizontal then Direction.RIGHT else Direction.DOWN
    setTimeout @generateNextPart(Direction.RIGHT), 50

    return

  # Finish recursive path generation
  if @current[toFinishAttr] == @finish[toFinishAttr] - 1 and @current[varAttr] == @finish[varAttr]
    @current[toFinishAttr] += 1
    @addToPath @current
    console.log 'Finished creating random path \\o/ (length=' + @pathLength + ')'

    return

  # go in a random direction (we repeat this step until we found a direction we can really go to)
  while needToFindNext
    # timeout handling
    if (new Date).getTime() - startTime > 5000
      console.log 'Timeout after 5 seconds!! total=' + @pathLength
      console.log 'current.x=' + @current.x + '; current.y=' + @current.y
      console.log 'start.x=' + @start.x + '; start.y=' + @start.y
      console.log 'finish.x=' + @finish.x + '; finish.y=' + @finish.y
      break

    needToFindNext = @generatePartInRandomDirection(lastDir, preLastDir)

  return
