Crafty.c 'ActualFPS', do ->
  start = undefined
  frames = undefined
  currentFPS = undefined

  {
    init: ->
      start = (new Date).getTime()
      frames = 0
      @bind 'ExitFrame', ->
        newTime = (new Date).getTime()
        if newTime - start >= 1000
          currentFPS = frames
          frames = 0
          start = newTime
        else
          frames++
        return
      return

    FPS: ->
      currentFPS

  }
