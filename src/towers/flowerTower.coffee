Crafty.c 'FlowerTower',
  init: ->
    @requires 'Tower, flower_tower1'
    @range = 4
    @maxLevel = 10
    @shootingSpeed = 0.4

    # handle setting range, correct sprite (according to level) and tooltip text
    @bind 'TowerUpgraded', (actor) ->
      if actor == this
        @handleLevelup()
      return

    # initialize according to level (has to be delayed because level is set after initialization)
    @delay (->
      @handleLevelup()
      return
    ), 100, 0

    i = 0
    enemyNear = true

    @delay (->
      if i++ % 4 == 0
        enemyNear = @isEnemyNear()
      if @has('Enabled') and enemyNear
        @shoot()
      return
    ), @shootingSpeed * 1000, -1

    return

  handleLevelup: ->
    # set range according to level
    if @level == @maxLevel
      @range = 6
    else if @level >= 4
      @range = 5
    else
      @range = 4

    # set sprite according to level
    i = 1
    while i < Math.ceil(@level / 2)
      @removeComponent 'flower_tower' + i
      i++
    @addComponent 'flower_tower' + Math.ceil(@level / 2)

    # update tooltip (what a surprise)
    @updateTooltip()

    return

  updateTooltip: ->
    @tooltip 'Flower Tower at level ' + @level + ', <br>' + @getDamage() + ' damage per petal, <br>' + @getDamage() / @shootingSpeed + ' dps in a square of ' + @range + ' tiles <br>' + @getUpgradeText()
    return

  shoot: ->
    x = @at().x
    y = @at().y
    bulletUp = undefined
    bulletRight = undefined
    bulletDown = undefined
    bulletLeft = undefined

    if Game.options.bulletImages
      bulletUp = Crafty.e('Bullet, leaf_up')
      bulletRight = Crafty.e('Bullet, leaf_right')
      bulletDown = Crafty.e('Bullet, leaf_down')
      bulletLeft = Crafty.e('Bullet, leaf_left')
    else
      bulletUp = Crafty.e('Bullet').attr(
        w: 16
        h: 16)
      bulletRight = Crafty.e('Bullet').attr(
        w: 16
        h: 16)
      bulletDown = Crafty.e('Bullet').attr(
        w: 16
        h: 16)
      bulletLeft = Crafty.e('Bullet').attr(
        w: 16
        h: 16)

    bulletUp.attr(damage: @getDamage()).at(x, y).animateTo(x, y - (@range), 4).destroyAfterAnimation()
    bulletRight.attr(damage: @getDamage()).at(x, y).animateTo(x + @range, y, 4).destroyAfterAnimation()
    bulletDown.attr(damage: @getDamage()).at(x, y).animateTo(x, y + @range, 4).destroyAfterAnimation()
    bulletLeft.attr(damage: @getDamage()).at(x, y).animateTo(x - (@range), y, 4).destroyAfterAnimation()

    return

  isEnemyNear: ->
    x1 = @at().x - (@range) - 2
    x2 = @at().x + @range + 2
    y1 = @at().y - (@range) - 2
    y2 = @at().y + @range + 2
    result = false

    # potentially very calculation intensive to do this
    Crafty('Enemy').each ->
      #noinspection JSPotentiallyInvalidUsageOfThis
      at = @at()
      if at.x >= x1 and at.x <= x2 and at.y >= y1 and at.y <= y2
        result = true
      return

    result

  getDamage: ->
    if @level < 6
      @level
    else
      Math.floor Math.sqrt(@level - 5) * @level

  getUpgradeCost: (level) ->
    if level == undefined
      level = @level

    Math.floor Game.towers['FlowerTower'] * Math.pow 1.4, level
