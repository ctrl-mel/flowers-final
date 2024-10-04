# Loading scene
# -------------
# Handles the loading of binary assets such as images and audio files
Crafty.scene 'Loading', ->
  # Draw some text for the player to see in case the file
  #  takes a noticeable amount of time to load
  loading = Crafty.e('2D, Grid, DOM, Text, Delay').text('Loading...').attr(w: Game.width()).at(0, 5).textFont(Game.loadingFont).textColor(Game.textColor).css(Game.centerCss)
  Crafty.e('2D, Grid, DOM, Progress, Text').at(Game.map_grid.width / 2 - 2, 8).textFont(Game.loadingFont).textColor(Game.textColor).text '0%'


  # pre-load some (small) assets that we need immediately
  x = 3
  Crafty.load Game.preLoadAssets, ->
    loading.delay (->
      if x >= 22
        Crafty('flower Loading').destroy()
        x = 3
      Crafty.e('2D, DOM, Grid, flower, Loading').at x, 10
      x += 2
      return
    ), 500, -1
    return


  # Load all our assets
  onLoad = ->
    # Now that our sprites are ready to draw, start the game
    Game.endless = false
    Game.userClicked = false
    Crafty.scene 'MainMenu'
    return
  onProgress = (progress) ->
    Crafty('Progress').text Math.floor(progress.percent) + '%'
    return
  onError = (asset) ->
    console.error('Could not load asset ' + asset)
    return

  Crafty.load Game.assets, onLoad, onProgress, onError

  return
