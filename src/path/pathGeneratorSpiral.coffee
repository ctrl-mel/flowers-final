###*
# Generates a spiral like path
# @param path
###
class PathGeneratorSpiral
  constructor: (path, start, finish) ->
    @path = path

    if start
      @start = start
    else
      @start =
        x: 0
        y: 1

    if finish
      @finish = finish
    else
      @finish =
        x: @path.width - 1
        y: @path.height - 2

    return


  generate: ->
    @path.start = @start
    @path.finish = @finish
    @path.current =
      x: @start.x
      y: @start.y

    # start off at the top left
    @path.addToPath @path.current
    @path.createPathElementIgnoreBorders Direction.RIGHT

    # actually generate the spiral
    @direction = new Direction(Direction.DOWN)
    console.log 'Generating inward spiral'
    @inwardSpiral()
    console.log 'Generating spiral intersection'
    @spiralIntersection()
    console.log 'Generating outward spiral'
    @outwardSpiral()

    # finish it all off
    @path.createPathElementIgnoreBorders Direction.RIGHT

    console.log 'Finished creating spiral, path length is: ' + @path.pathLength

    @path


  inwardSpiral: ->
    startTime = (new Date).getTime()

    # adjust top and right to be a bit out of bounds, because we reduce them in the first round
    @path.top = 1 - 2
    @path.right = @path.width - 2 + 2 # ???

    # create spiral by continuously reducing the borders of the bounding rectangle
    # this goes on until our borders collapse, leaving an empty bounding rectangle behind
    while @path.top < @path.bottom - 1 and @path.left < @path.right - 1
      # timeout handling
      if (new Date).getTime() - startTime > 5000
        console.log 'Timeout after 5 seconds!! total=' + @path.pathLength
        console.log 'current.x=' + @path.current.x + '; current.y=' + @path.current.y
        console.log 'start.x=' + @start.x + '; start.y=' + @start.y
        console.log 'finish.x=' + @finish.x + '; finish.y=' + @finish.y
        break

      # create path element; if that fails, rotate direction by 90 degrees counter clockwise and
      # reduce border in that direction to continue spiral
      if not @path.createPathElement(@direction.value)
        # rotate direction counter clockwise (e.g. DOWN to RIGHT)
        @direction.turnLeft()

        # reduce border into which we will go next
        switch @direction.value
          when Direction.DOWN
            @path.bottom -= 4
          when Direction.RIGHT
            @path.right -= 4
          when Direction.UP
            @path.top += 4
          when Direction.LEFT
            @path.left += 4

      console.log()

    return


  spiralIntersection: ->
    # shift borders so that the path in outwardSpiral spirals
    # into the gaps that inwardSpiral created (or rather left behind)
    switch @direction.value
      when Direction.DOWN
        @path.top += 2
        @path.bottom += 2
        @path.left -= 2
        @path.right -= 2
      when Direction.RIGHT
        @path.top += 2
        @path.bottom += 2
        @path.left += 2
        @path.right += 2
      when Direction.UP
        @path.top -= 2
        @path.bottom -= 2
        @path.left += 2
        @path.right += 2
      when Direction.LEFT
        @path.top -= 2
        @path.bottom -= 2
        @path.left -= 2
        @path.right -= 2

    # rotate direction clockwise (e.g. BOTTOM to LEFT)
    @direction.turnRight()

    # continue path for 2 more steps to fill the gap
    @path.createPathElementIgnoreBorders @direction.value
    @path.createPathElementIgnoreBorders @direction.value

    return


  outwardSpiral: ->
    startTime = (new Date).getTime()

    # create spiral by continuously expanding the borders of the bounding rectangle
    # this goes on until we reach the finish point
    while @path.current.x < @path.finish.x - 1 or @path.current.y < @path.finish.y
      # timeout handling
      if (new Date).getTime() - startTime > 5000
        console.log 'Timeout after 5 seconds!! total=' + @path.pathLength
        console.log 'current.x=' + @path.current.x + '; current.y=' + @path.current.y
        console.log 'start.x=' + @start.x + '; start.y=' + @start.y
        console.log 'finish.x=' + @finish.x + '; finish.y=' + @finish.y
        break

      # create path element; if that fails, rotate direction by 90 degrees clockwise and
      # expand border in that direction to continue spiral
      if not @path.createPathElement(@direction.value)
        # rotate direction clockwise (e.g. BOTTOM to LEFT)
        @direction.turnRight()
        # expand border into which we will go next
        switch @direction.value
          when Direction.DOWN
            @path.bottom += 4
          when Direction.RIGHT
            @path.right += 4
          when Direction.UP
            @path.top -= 4
          when Direction.LEFT
            @path.left -= 4

    return


# make this class known outside
window.PathGeneratorSpiral = PathGeneratorSpiral
