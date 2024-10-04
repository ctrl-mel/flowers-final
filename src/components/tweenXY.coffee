Crafty.c 'TweenXY',
  init: ->
    @requires '2D'
    return

  moveTo: (x, y, ms) ->
    timePerFrame = 1000 / Crafty.timer.FPS()
    speed = Math.max(Math.abs(x - (@x)), Math.abs(y - (@y))) * timePerFrame / ms

    animation =
      actor: this
      speed: speed
      steps: [ {
        x: x
        y: y
      } ]

    tweening = Crafty.e 'TweeningHandler'
    tweening.targets.push animation

    this
