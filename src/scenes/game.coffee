# Main game scene
# ---------------
Crafty.scene 'Game', ->
  # Create wave
  wave = Crafty.e 'Wave'

  # background
  Crafty.e '2D, Canvas, ' + Game.backgroundAsset

  # play background music
  Crafty.audio.stop()
  Crafty.audio.play 'Background', -1, 0.35

  # HUD
  Crafty.e('HudElement').observe('Money', 'money', '$').at 1
  Crafty.e('HudElement').observe('Lifes', 'lifes').at(6).alertIfBelow 3
  Crafty.e('HudElement').observe('Enemies', 'enemyCount').at 10
  Crafty.e('HudElement').observe('Wave', 'currentWave').at 14
  Crafty.e('HudElement').observe('FPS', Game.actualFPS.FPS).at 18

  # restart level button
  Crafty.e('DOMButton, Grid').text('Restart level').tooltip('Restart this level with difficulty ' + Game.difficulty + ' at wave 1')
                             .textColor(Game.highlightColor).textFont(Game.hudFont).unbind('Click').bind('Click', ->
    # FIXME should this rather be triggered?
    Crafty.e('RestartLevel')
    Crafty.bind 'RestartLevel', ->
      console.log 'Restarting level at ' + Game.level

      # we need crafty unpaused for initialization
      if Crafty.isPaused()
        Crafty.pause()

      # clear savegame
      Crafty.storage.remove('ftd_save1')

      # reset difficulty-related properties
      Game.setDifficultyProperties Game.difficulty
      Crafty.scene 'InitializeLevel' + Game.level

    return
  ).at(20, 0).attr w: 180

  # tower selectors
  Crafty.e('TowerSelector').forTower('FlowerTower').attr(
    tooltipWidth: 500
    tooltipHeight: 130).tooltip('Click here to select the Flower Tower.<br> If you click anywhere on the map you build this tower.<br>' +
        'It shoots in all 4 directions with limited range.<br> Gains higher range on upgrade.<br> Hotkey: C'
        ).withSprite('flower_tower5').withHotkey('C').at 1, Game.map_grid.height - 1
  Crafty.e('TowerSelector').forTower('SniperTower').attr(
    tooltipWidth: 500
    tooltipHeight: 130).tooltip('Click here to select the Sniper Tower.<br> If you click anywhere on the map you build this tower.<br> ' +
        'It shoots anywhere on the map, but cost increases.<br> Gains instant kill on highest level.<br> Hotkey: V'
        ).withSprite('sniper_tower4').withHotkey('V').at 3, Game.map_grid.height - 1

  # lose condition: no more lives
  Crafty.bind 'EnterFrame', ->
    if Game.lifes <= 0
      Crafty.unbind 'EnterFrame'
      Crafty.scene 'GameOver'
    return

  # listener once a wave is finished (auto save game, wave start indicator)
  Crafty.bind 'WaveFinished', (waveNumber) ->
    # save game
    Crafty.storage 'ftd_save1', Game
    console.log('Automatically saved game')

    # make all flower towers shoot to indicate new wave
    Crafty.e('WaveStartIndicator')

    return

  # listener once last wave was finished (game won, clear save game)
  Crafty.bind 'LastWaveFinished', ->
    # TODO automatically set endless rather than clearing save game
    # clear save game
    Crafty.storage.remove 'ftd_save1'

    # game won
    Crafty.unbind 'EnterFrame'
    Crafty.scene 'Won'

  # when a tower gets built then its type and (as level 1) gets written into the tower map (for saving/loading)
  Crafty.bind 'TowerCreated', (tower) ->
    # insert in tower map
    towerNames = [
      'FlowerTower'
      'SniperTower'
    ]
    i = 0
    while i < towerNames.length
      if tower.has(towerNames[i])
        Game.towerMap[tower.at().x][tower.at().y].name = towerNames[i]
        Game.towerMap[tower.at().x][tower.at().y].level = 1
        return
      i++
    return

  # when a tower gets upgraded its new level gets written into the tower map
  Crafty.bind 'TowerUpgraded', (tower) ->
    # update tower map
    Game.towerMap[tower.at().x][tower.at().y].level = tower.level
    return

  # Populate our playing field with trees, path tiles, towers and tower places
  # we need to reset sniper tower cost, because when placing them in the loop the cost goes up again
  Game.towers['SniperTower'] = Game.sniperTowerInitial
  #console.log(Game.towerMap);

  x = 0
  while x < Game.map_grid.width
    y = 0
    while y < Game.map_grid.height
      if Game.path.isOnEdge(x, y)
        Crafty.e('Tree').at x, y
      else if Game.path.isOnPath(x, y)
        Crafty.e('Path').at x, y
      else if Game.towerMap[x][y].level > 0
        Crafty.e(Game.towerMap[x][y].name).at(x, y).attr('level': Game.towerMap[x][y].level).updateTooltip()
      else
        Crafty.e('TowerPlace').at x, y
      y++
    x++

  # initialize wave (handles spawning of every wave)
  Crafty.e('WaveButton').attr(wave: wave).at Game.map_grid.width - 5, Game.map_grid.height - 1

  # initialize sidebar
  Crafty.e 'Sidebar'

  # help button
  # FIXME put help button into own component, rework
  Crafty.e('DOMButton, Grid').text('Help').textFont(Game.waveFont).at(10, Game.map_grid.height - 1).attr(w: 100).tooltip('If you are lost, look here').bind 'Click', ->
    # create an overlay that explains the general concept
    overlay = document.getElementById('helpOverlay')
    if overlay
      overlay.parentNode.removeChild overlay
    else
      overlay = document.createElement('div')
      overlay.setAttribute 'id', 'helpOverlay'
      overlay.style.position = 'absolute'
      overlay.style.width = Game.width() - 40 + 'px'
      overlay.style.padding = '10px'
      overlay.style.left = '10px'
      overlay.style.top = '30px'
      overlay.style.border = '1px solid black'
      overlay.style.background = 'grey'
      overlay.style.zIndex = '1000'
      overlay.innerHTML = '<p>Click anywhere to build the selected tower type. ' +
          'You can find the selected tower type in the lower left of the screen (black is selected).' +
          '</p><p>' + 'When you click on an already built tower you upgrade that tower. ' +
          'The costs and the current tower level are displayed on mouse over ' +
          'in the top right of the screen (Cost and Level).' + '</p><p>' +
          '<em><strong>There are two tower types to choose from, ' +
          'with the first one automatically selected:</strong></em>' + '</p><p>' +
          'The first tower type shoots leafs into all 4 directions, which damage the enemy on impact. ' +
          'They have a limited range so build these towers near the path. ' +
          'Their range increases on higher levels.' + '</p><p>' +
          'The second tower shoots all over the map at a single random target.' +
          'The first tower you build of this type is relatively cheap, ' +
          'but each one after the first one gets more and more expensive. ' +
          'Upgrading, however, always costs the same.<br>' +
          'This tower gains a 2% chance to instantly kill an enemy on its highest level.' + '</p><p>' +
          'You have to start the first wave by clicking "Start". ' +
          'After that the waves come automatically, ' +
          'but you can start the next wave earlier by clicking "Next Wave" again.' + '</p><p>' +
          'You win if you finish all 15 waves. You can challenge yourself ' +
          'and see how far you can get in endless mode after that.' + '</p>'
      document.getElementById('cr-stage').appendChild overlay

  Crafty.e 'PauseButton'

  Crafty.e('DOMButton, Grid').text('Main Menu').textFont(Game.waveFont).attr(
    w: 200
    h: 50).at(5, Game.map_grid.height - 1).tooltip('Clicking this button returns you to the main menu').bind('Click', ->
      console.log 'Main Menu'
      wave.cancelWave()
      Crafty.scene 'MainMenu'
      return
  )

  Crafty.e('SoundButton, Grid').textFont(Game.waveFont).attr(
    w: 150
    h: 50).at 16, Game.map_grid.height - 1
