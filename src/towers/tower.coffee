Crafty.c 'Tower',
  init: ->
    @requires '2D, Canvas, Grid, Mouse, Tooltip, Color, Delay, Enabled'
    @attr
      level: 1
      tooltipWidth: 250
      tooltipHeight: 110

    if Crafty.mobile
      @bind 'MouseUp', ->
        if @previousMouseUp
          @upgrade()
        else
          @previousMouseUp = true
        return
    else
      @bind 'Click', ->
        if Crafty('Sidebar').selectedTower == this
          @upgrade()
        else
          Crafty('Sidebar').openFor this
        return

    return

  isUpgradable: ->
    @level < @maxLevel

  upgrade: ->
    upgradeCost = @getUpgradeCost()
    if @isUpgradable()
      if Game.money >= upgradeCost
        @level++
        Game.money -= upgradeCost
        Crafty.trigger 'TowerUpgraded', this
      console.log 'Upgraded tower (' + @at().x + '/' + @at().y + ') for ' + upgradeCost
    else
      console.log 'Tower (' + @at().x + '/' + @at().y + ') at max level, can\'t upgrade it'

    return

  getUpgradeText: ->
    if @isUpgradable()
      '(Upgrade costs ' + @getUpgradeCost() + '$) <br>'
    else
      '(maximum level reached)'

  sell: ->
    Game.money += @getSellValue()
    Crafty.trigger 'TowerSold', this
    @destroy()
    console.log 'Sold tower for ' + @getSellValue() + '$'
    return

  getSellValue: ->
    totalCost = 0
    level = 1

    while level <= @level
      levelCost = @getUpgradeCost(level)
      if levelCost != 'MAX'
        totalCost += levelCost
      level++

    Math.floor totalCost * 0.5
