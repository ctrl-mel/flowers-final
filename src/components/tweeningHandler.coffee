# -------------------------------------
# custom Tween handling (only movement)
# -------------------------------------
Crafty.c 'TweeningHandler',
  init: ->
    @attr
      targets: []
      stepsPerGrid: 25

    @bind 'EnterFrame', @tweenHandler

    return

  moveActor: (current, distanceX, distanceY) ->
    newX = current.actor.x
    newY = current.actor.y

    if current.actor.x < current.steps[0].x
      newX = Math.min(current.actor.x + distanceX, current.steps[0].x)
    else if current.actor.x > current.steps[0].x
      newX = Math.max(current.actor.x - distanceX, current.steps[0].x)

    if current.actor.y < current.steps[0].y
      newY = Math.min(current.actor.y + distanceY, current.steps[0].y)
    else if current.actor.y > current.steps[0].y
      newY = Math.max(current.actor.y - distanceY, current.steps[0].y)

    current.actor.attr
      x: newX
      y: newY

    return

  triggerDirectionChanged: (current) ->
    if current.steps.length == 0
      return

    if current.steps[0].x < current.actor.x
      Crafty.trigger 'TweenDirectionChanged', current.actor, 'left'
    else if current.steps[0].x > current.actor.x
      Crafty.trigger 'TweenDirectionChanged', current.actor, 'right'
    else if current.steps[0].y < current.actor.y
      Crafty.trigger 'TweenDirectionChanged', current.actor, 'up'
    else if current.steps[0].y > current.actor.y
      Crafty.trigger 'TweenDirectionChanged', current.actor, 'down'

    return

  tweenHandler: ->
    if Crafty.isPaused()
      return

    i = 0
    while i < @targets.length
      current = @targets[i]
      distanceX = current.speed * Game.map_grid.tile.width / @stepsPerGrid
      distanceY = current.speed * Game.map_grid.tile.height / @stepsPerGrid

      if current.actor.x != current.steps[0].x or current.actor.y != current.steps[0].y
        @moveActor current, distanceX, distanceY
      else
        # remove this step from steps, so we can continue with next step
        current.steps.shift()
        @triggerDirectionChanged current

      # no more steps to take for current target: remove it from tween_targets array
      if current.steps.length == 0
        @targets.splice i, 1
        i--
        Crafty.trigger 'TweenEnded', current.actor

      i++

    return
