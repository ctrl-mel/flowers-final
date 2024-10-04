# Main menu - load old savegame or start new game
# ----------------------------
Crafty.defineScene 'MainMenu', (attributes) ->
  # background
  Crafty.background Game.mainMenuBackgroundColor

  # play main menu music after click
  # we have to wait for user interaction first before we can play audio (at least the first time around)
  startMainMenuMusic = ->
    Crafty.audio.stop()
    Crafty.audio.play 'Menu', -1, 0.5

  if Game.userClicked and (not attributes or not attributes.dontRestartMenuMusic)
    startMainMenuMusic()
  else
    Crafty.e('2D, DOM, Mouse').attr(
      x: 0
      y: 0
      w: Game.width()
      h: Game.height()
    ).bind 'Click', ->
      if not Game.userClicked
        startMainMenuMusic()
        Game.userClicked = true

      return

  # logo
  Crafty.e('2D, DOM, Image').image('assets/images/ftd-logo.jpg').attr
    x: 80
    y: Game.height() * 1 / 12 - 24
    w: Game.width()
    h: 200

  savegame = Crafty.storage('ftd_save1')

  # load savegame button
  loadButton = Crafty.e('DOMButton').text('Load Saved game').attr(
    x: 0
    y: Game.height() * 7 / 12 - 24
    w: Game.width()
    h: 50
    tooltipWidth: 350
  ).bind 'Click', ->
    Game.userClicked = true
    console.log('User clicked, set Game.userClicked to true')

  if savegame
    loadButton.tooltip('Continue the game you played last time ' + 'with difficulty ' + savegame.difficulty + ' ' + 'on wave ' + savegame.currentWave).bind 'Click', ->
      Game.difficulty = savegame.difficulty or 'Normal'
      Game.money = savegame.money
      Game.lifes = savegame.lifes
      Game.moneyAfterWave = savegame.moneyAfterWave
      Game.towers = savegame.towers
      Game.level = savegame.level or '2'
      Game.backgroundAsset = savegame.backgroundAsset or 'background1'
      Game.waves.current = savegame.waves.current or Game.waves.level2
      Game.endless = savegame.currentWave >= Game.waves.current.length
      Game.enemyCount = savegame.enemyCount
      Game.currentWave = savegame.currentWave
      Game.selectedTower = savegame.selectedTower
      Game.sniperTowerInitial = savegame.sniperTowerInitial
      Game.towerMap = savegame.towerMap
      Game.path = new Path(Game.map_grid)
      Game.path.copy savegame.path
      Game.enemyCount = 0

      Crafty.scene 'Game'
      return
  else
    loadButton.tooltip('No savegame exists yet.').disable()

  # start new game button
  Crafty.e('DOMButton').text('Start new game').attr(
    x: 0
    y: Game.height() * 9 / 12 - 24
    w: Game.width()
    h: 50).tooltip('Starts a new game. You can select the difficulty on the next screen.').bind 'Click', ->
      # function to actually start the game
      startGame = ->
        # start main menu music
        if not Game.userClicked
          startMainMenuMusic()
          Game.userClicked = true

        Crafty.scene 'Difficulty'

      if savegame
        # savegame exists: show overwrite savegame overlay
        Crafty.e('OverwriteSavegame').attr(
          y: Game.height() * 9 / 12 - 24 - 20
        ).showOverlay()
        Crafty.bind 'OverwriteSavegameConfirmed', ->
          Crafty.storage.remove('ftd_save1')
          startGame()
      else
        startGame()

      return

  # instructions button
  Crafty.e('DOMButton').text('Instructions').attr(
    x: 70
    y: Game.height() - 50
    w: 200
    h: 50).tooltip('Click here for some instructions').bind 'Click', ->
      # start main menu music
      if not Game.userClicked
        startMainMenuMusic()
        Game.userClicked = true

      Crafty.scene 'Help', 'MainMenu'
      return

  # credits button
  Crafty.e('DOMButton').text('Credits').attr(
    x: 280
    y: Game.height() - 50
    w: 200
    h: 50).tooltip('View the credits for this game ^^').bind 'Click', ->
      # start main menu music
      if not Game.userClicked
        startMainMenuMusic()
        Game.userClicked = true

      Crafty.scene 'Credits', 'MainMenu'
      return

  # sound button
  Crafty.e('SoundButton').attr(
    x: 470
    y: Game.height() - 50
    w: 200
    h: 50).bind 'Click', ->
      # start main menu music
      if not Game.userClicked
        startMainMenuMusic()
        Game.userClicked = true
      return

  return
