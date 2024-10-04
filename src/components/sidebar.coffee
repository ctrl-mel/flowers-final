Crafty.c 'Sidebar',
  init: ->
    @requires '2D, DOM, Mouse, Color'
    @attr
      x: 0
      y: Game.map_grid.tile.height
      w: 170
      h: Game.height() - (2 * Game.map_grid.tile.height)
      z: 100
    @color '#777777', 0.42

    @bind 'MouseOver', (e) ->
      e.preventDefault()
      return

    sidebar = this
    closeButton = Crafty.e('DOMButton').attr(
      x: sidebar.w - 27
      y: @y
      w: 25
      h: 25
      z: 101
      tooltipWidth: 50
      tooltipHeight: 75).textFont(Game.closeFont).css(Game.closeCss).text('x').tooltip('Closes the sidebar').bind('Click', ->
        sidebar.close()
        return
    )

    @upgradeHeadline = Crafty.e('2D, DOM, Text').attr(
      x: 0
      y: 70
      w: sidebar.w
      z: 101).textColor(Game.textColor).textFont(Game.sidebarFont)

    @upgradeButton = Crafty.e('DOMButton').attr(
      x: 0
      y: 160
      w: sidebar.w
      h: 40
      z: 101).bind('Click', ->
        sidebar.selectedTower.upgrade()
        return
    )

    @sellHeadline = Crafty.e('2D, DOM, Text').attr(
      x: 0
      y: 260
      w: sidebar.w
      z: 101).textColor(Game.textColor).textFont(Game.sidebarFont)

    @sellButton = Crafty.e('DOMButton').attr(
      x: 0
      y: 330
      w: sidebar.w
      h: 40
      z: 101).bind('Click', ->
        Crafty.e('TowerPlace').at sidebar.selectedTower.at().x, sidebar.selectedTower.at().y
        sidebar.selectedTower.sell()
        sidebar.close()
        return
    )

    @attach closeButton
    @attach @upgradeHeadline
    @attach @upgradeButton
    @attach @sellHeadline
    @attach @sellButton

    @close()

    @bind 'TowerUpgraded', ->
      sidebar.updateTexts()
      return

    return

  highlightTower: ->
    Crafty('Sidebar').selectedTower.color '#ffffff', 0.3
    return

  openFor: (selectedTower) ->
    if @selectedTower
      @selectedTower.unbind 'MouseOut', @highlightTower
      @selectedTower.color '#ffffff', 0.0

    @selectedTower = selectedTower
    @selectedTower.bind 'MouseOut', @highlightTower

    if @selectedTower.x < Game.width() / 2
      @x = Game.width() - (@w) - (Game.map_grid.tile.width)
    else
      @x = Game.map_grid.tile.width

    @updateTexts()

    return

  updateTexts: ->
    towerType = if @selectedTower.has('SniperTower') then 'Sniper Tower' else 'Flower Tower'

    if @selectedTower.isUpgradable()
      @upgradeHeadline.text 'Upgrade ' + towerType + ' to level ' + (@selectedTower.level + 1) + ':'
      @upgradeButton.text('-' + @selectedTower.getUpgradeCost() + '$').tooltip 'Upgrade ' + towerType + ' at position (' + @selectedTower.at().x + '/' + @selectedTower.at().y + ')' + ' to level ' + (@selectedTower.level + 1) + ' for ' + @selectedTower.getUpgradeCost() + '$'
    else
      @upgradeHeadline.text towerType + ': Maximum level reached'
      @upgradeButton.text('-').tooltip 'Maximum level reached, can\'t upgrade tower'

    @sellHeadline.text 'Sell ' + towerType + ':'
    @sellButton.text('+' + @selectedTower.getSellValue() + '$').tooltip 'Sell ' + towerType + ' at position (' + @selectedTower.at().x + '/' + @selectedTower.at().y + ')' + ' to get back ' + @selectedTower.getSellValue() + '$'

    return

  close: ->
    @x = -@w - 50
    if @selectedTower
      @selectedTower.unbind 'MouseOut', @highlightTower
      @selectedTower.color '#ffffff', 0.0
    @selectedTower = null

    return
