# show Won screen, with "start again" button
Crafty.scene 'Won', ->
  Crafty.background Game.wonColor
  Crafty.audio.stop()
  Crafty.audio.play 'Won', -1

  Crafty.e('2D, DOM, Image').image('assets/images/ftd-logo.jpg').attr
    x: 80
    y: Game.height() * 1 / 12 - 24
    w: Game.width()
    h: 200

  Crafty.e('2D, DOM, Text').text('You won!! PW: Kastanien11! ').attr(
    x: 0
    y: Game.height() * 7 / 12 - 24
    w: Game.width()
    h: 50).textFont(Game.wonFont).textColor(Game.textColor).css Game.centerCss

  Crafty.e('DOMButton').text('Continue in endless mode?')
  .tooltip('Click here to continue your last game from wave ' + Game.waves.current.length)
  .attr(
    x: 0
    y: Game.height() * 9 / 12 - 24
    w: Game.width()
    h: 50).textFont(Game.continueFont).textColor(Game.continueColor).bind 'Click', ->
      Game.endless = true
      Crafty.scene 'Game'
      return

  Crafty.e('RestartButton').attr
    x: 0
    y: Game.height() * 11 / 12 - 24
    w: Game.width()
    h: 50
