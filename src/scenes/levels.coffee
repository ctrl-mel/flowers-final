# Initialize variables for new game
# Every level is listed here
# ---------------------------------
Crafty.scene 'InitializeLevel1', ->
  # show loading if initialization takes up some time ...
  loading = Crafty.e('2D, DOM, Text, Delay').text('Loading level, generating map...').attr(
    x: 0
    y: Game.height() / 2 - 24
    w: Game.width()).textFont(Game.loadingFont).textColor(Game.textColor).css(Game.centerCss)

  Game.level = '1'
  Game.backgroundAsset = 'background1'
  Game.waves.current = Game.waves.level1
  Game.setGeneralProperties()

  # generate path like this:
  # -  /-----------\
  # |  |           |
  # |  |  /-----\  |
  # |  |  |     |  |
  # |  |  \--\  |  |
  # |  |     |  |  |
  # |  \-----/  |  |
  # |           |  |
  # \-----------/  -

  loading.delay (->
    Game.path = new Path(Game.map_grid)
    new PathGeneratorSpiral(Game.path).generate()

    Crafty.scene 'Game'

    return
  ), 400

  return


Crafty.scene 'InitializeLevel2', ->
  # show loading if initialization takes up some time ...
  loading = Crafty.e('2D, DOM, Text, Delay').text('Loading level, generating map...').attr(
    x: 0
    y: Game.height() / 2 - 24
    w: Game.width()).textFont(Game.loadingFont).textColor(Game.textColor).css(Game.centerCss)

  Game.level = '2'
  Game.backgroundAsset = 'background2'
  Game.waves.current = Game.waves.level2
  Game.setGeneralProperties()

  loading.delay (->
    # generate path
    Game.path = new Path(Game.map_grid)
    Game.path.generatePath()

    Crafty.scene 'Game'

    return
  ), 400

  return


Crafty.scene 'InitializeLevel3', ->
  # show loading if initialization takes up some time ...
  loading = Crafty.e('2D, DOM, Text, Delay').text('Loading level, generating map...').attr(
    x: 0
    y: Game.height() / 2 - 24
    w: Game.width()).textFont(Game.loadingFont).textColor(Game.textColor).css(Game.centerCss)

  Game.level = '3'
  Game.backgroundAsset = 'background6'
  Game.waves.current = Game.waves.level3
  Game.setGeneralProperties()

  loading.delay (->
    # generate path
    Game.path = new Path(Game.map_grid)
    Game.path.generateStartOnRow 0
    Game.path.finish =
      x: 14
      y: Game.map_grid.height - 1
    Game.path.generatePath()

    Crafty.scene 'Game'

    return
  ), 400

  return


Crafty.scene 'InitializeLevel4', ->
  # show loading if initialization takes up some time ...
  loading = Crafty.e('2D, DOM, Text, Delay').text('Loading level, generating map...').attr(
    x: 0
    y: Game.height() / 2 - 24
    w: Game.width()).textFont(Game.loadingFont).textColor(Game.textColor).css(Game.centerCss)

  Game.level = '4'
  Game.backgroundAsset = 'background5'
  Game.waves.current = Game.waves.level4
  Game.setGeneralProperties()

  loading.delay (->
    # generate path
    map_config =
      width: Game.map_grid.width
      height: Game.map_grid.height
      tile: Game.map_grid.tile
      pathMinLength: 5
      pathMaxLength: 20

    Game.path = new Path(map_config)
    Game.path.start =
      x: 9
      y: 0
    Game.path.finish =
      x: 14
      y: Game.map_grid.height - 1
    Game.path.generatePath()

    Crafty.scene 'Game'

    return
  ), 400

  return


Crafty.scene 'InitializeLevel5', ->
  # show loading if initialization takes up some time ...
  loading = Crafty.e('2D, DOM, Text, Delay').text('Loading level, generating map...').attr(
    x: 0
    y: Game.height() / 2 - 24
    w: Game.width()).textFont(Game.loadingFont).textColor(Game.textColor).css(Game.centerCss)

  Game.level = '5'
  Game.backgroundAsset = 'background9'
  Game.waves.current = Game.waves.level5
  Game.setGeneralProperties()

  loading.delay (->
    # generate path
    Game.path = new Path(Game.map_grid)
    Game.path.pathMaxLength = 110
    Game.path.generateStartOnRow 0
    Game.path.generateFinishInColumn 0
    Game.path.generateLabyrinth()

    Crafty.scene 'Game'

    return
  ), 400

  return
