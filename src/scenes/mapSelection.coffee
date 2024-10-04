Crafty.scene 'MapSelection', ->
  Crafty.background Game.mapSelectionBackgroundColor

  currentPage = 1

  Crafty.e('2D, DOM, Image').image('assets/images/ftd-logo.jpg').attr
    x: 80
    y: Game.height() * 1 / 12 - 24
    w: Game.width()
    h: 200

  Crafty.e('2D, DOM, Text').text('Choose a map:').attr(
    x: 0
    y: Game.height() * 3 / 6 - 24
    w: Game.width()
    h: 50).textFont(Game.mapSelectionFont).textColor(Game.textColor).css Game.centerCss

  # FIXME put prev and next buttons into components
  Crafty.e('DOMButton, Delay, Previous').text('Prev').attr(
    x: Game.width() * 1 / 24
    y: Game.height() * 8 / 12 - 24
    w: Game.width() * 2 / 24
    h: 32).tooltip('Show previous page of levels').disable().bind 'Click', ->
      if @buttonEnabled
        currentPage--
        @disable()

        @delay (->
          if currentPage > 1
            @enable()
          Crafty('DOMButton Next').enable()
          return
        ), 1000

        Crafty('LevelSelector').each ->
          @moveTo @x + Game.width(), @y, 800
          return

      return

  Crafty.e('DOMButton, Delay, Next').text('Next').attr(
    x: Game.width() * 21 / 24
    y: Game.height() * 8 / 12 - 24
    w: Game.width() * 2 / 24
    h: 32).tooltip('Show next page of levels').bind 'Click', ->
      if @buttonEnabled
        currentPage++
        @disable()

        @delay (->
          if currentPage < Crafty('Level').length / 3.0
            @enable()
          console.log Crafty('Level').length
          Crafty('DOMButton Previous').enable()
          return
        ), 1000

        Crafty('LevelSelector').each ->
          @moveTo @x - Game.width(), @y, 800
          return

      return

  Crafty.e('LevelSelector').level('1').tooltip('10 Waves of enemies who travel through a large spiral.').attr
    x: Game.width() * 4 / 24
    y: Game.height() * 8 / 12 - 24
    w: Game.width() / 6
    h: 100

  Crafty.e('LevelSelector').level('2').tooltip('15 Waves of enemies who travel from left to right.').attr
    x: Game.width() * 10 / 24
    y: Game.height() * 8 / 12 - 24
    w: Game.width() / 6
    h: 100

  Crafty.e('LevelSelector').level('3').tooltip('15 Waves of enemies who go from top to bottom.').attr
    x: Game.width() * 16 / 24
    y: Game.height() * 8 / 12 - 24
    w: Game.width() / 6
    h: 100

  Crafty.e('LevelSelector').level('4').tooltip('20 Waves in a fast-paced short path.').attr
    x: Game.width() * 28 / 24
    y: Game.height() * 8 / 12 - 24
    w: Game.width() / 6
    h: 100

  Crafty.e('LevelSelector').level('5').tooltip('15 Waves who travel through a maze.').attr
    x: Game.width() * 34 / 24
    y: Game.height() * 8 / 12 - 24
    w: Game.width() / 6
    h: 100

  # idea: level 6 is dual path (two starts, two finishes, two waves each wave, paths don't overlap)

  Crafty.e('DOMButton').text('Instructions').attr(
    x: 70
    y: Game.height() - 50
    w: 200
    h: 50).tooltip('Click here for some instructions').bind 'Click', ->
      Crafty.scene 'Help', 'MapSelection'
      return

  Crafty.e('DOMButton').text('Credits').attr(
    x: 280
    y: Game.height() - 50
    w: 200
    h: 50).tooltip('View the credits for this game ^^').bind 'Click', ->
      Crafty.scene 'Credits', 'MapSelection'
      return

  Crafty.e('SoundButton').attr
    x: 470
    y: Game.height() - 50
    w: 200
    h: 50
