Crafty.c 'SniperTower',
  init: ->
    @requires 'Tower, SpriteAnimation, sniper_tower1'
    @attr
      w: 32
      h: 32
    @maxLevel = 6

    # show correct sprite for level and update tooltip
    @bind 'TowerUpgraded', (actor) ->
      if actor == this
        @handleLevelup()
      return

    # if this tower is sold we reduce the cost for the next sniper tower again
    @bind 'TowerSold', (actor) ->
      if actor == this
        Game.towers['SniperTower'] = Math.floor(Game.towers['SniperTower'] / 1.25)
      return

    # increase cost for next sniper tower (we don't want to make it tooo easy ;) )
    @delay (->
      Game.towers['SniperTower'] = Math.floor(1.25 * Game.towers['SniperTower'])
      @handleLevelup()
      return
    ), 100, 0

    @delay (->
      if Game.enemyCount > 0 and @has('Enabled')
        @shoot()
      return
    ), 4000, -1

    return

  handleLevelup: ->
    # set sprite according to level
    i = 1
    while i < Math.ceil((@level + 1) / 2)
      @removeComponent 'sniper_tower' + i
      i++
    @addComponent 'sniper_tower' + Math.ceil((@level + 1) / 2)

    # update tooltip (what a surprise)
    @updateTooltip()

    return

  updateTooltip: ->
    @tooltip 'Sniper Tower at level ' + @level + ', <br>' + @getDamage() + ' damage per petal, <br>' + @getDamage() / 4 + ' dps on the whole map <br> ' + @getUpgradeText()
    return

  shoot: ->
    firstEnemy = Crafty('Enemy').get(0)

    # no first enemy? then we have nothing to shoot at
    if not firstEnemy
      return

    # instant kill with 2% chance on max level
    if @level == @maxLevel and Math.floor(Math.random() * 50) == 0 and !firstEnemy.noInstantKill
      console.log 'INSTANT KILL!!'
      firstEnemy.kill()
    else
      @delay (->
        firstEnemy.hitWithDamage @getDamage()
        return
      ), 500, 0

      x = @at().x
      y = @at().y
      x2 = Math.floor(firstEnemy.at().x)
      y2 = Math.floor(firstEnemy.at().y)
      if Game.options.bulletImages
        Crafty.e('Bullet, leaf_right').attr(damage: 0).at(x, y).animateTo(x2, y2, 35).destroyAfterAnimation()

    return

  getDamage: ->
    @level * 5

  getUpgradeCost: (level) ->
    if level == undefined
      level = @level
    Math.floor Game.towers['SniperTowerUpgrade'] * 1.5 * Math.sqrt(level)
