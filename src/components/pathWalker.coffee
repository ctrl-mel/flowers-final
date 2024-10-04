# The PathWalker component allows an entity to move along a path,
# given as an array of objects with x and y attributes
Crafty.c 'PathWalker',
  animateAlong: (path, speed) ->
    if !speed
      speed = 1

    animation =
      actor: this
      speed: speed
      steps: []

    i = 0
    while i < path.length
      animation.steps.push
        x: path[i].x * Game.map_grid.tile.width
        y: path[i].y * Game.map_grid.tile.height
      #console.log("Tweening to x=" + path[i].x + ", y=" + path[i].y);
      i++

    tweening = Crafty.e('TweeningHandler')
    tweening.targets.push animation

    this

  animateTo: (x, y, speed) ->
    @animateAlong [ {
      x: x
      y: y
    } ], speed

  destroyAfterAnimation: ->
    that = this
    Crafty.bind 'TweenEnded', (actor) ->
      if actor == that
        that.destroy()
      return

    this
