# Difficulty selection scene
# --------------------------
# User can decide on his difficulty here
Crafty.scene 'Difficulty', ->
  Crafty.background Game.difficultyBackgroundColor

  # logo
  Crafty.e('2D, DOM, Image').image('assets/images/ftd-logo.jpg').attr
    x: 80
    y: Game.height() * 1 / 12 - 24
    w: Game.width()
    h: 200

  Crafty.e('2D, DOM, Text').text('Choose your difficulty:').attr(
    x: 0
    y: Game.height() * 6 / 12 - 24
    w: Game.width()
    h: 50).textFont(Game.difficultyFont).textColor(Game.textColor).css Game.centerCss

  for e of Game.difficulties
    # skip difficulty if not exists
    if not Game.difficulties.hasOwnProperty(e)
      continue

    Crafty.e('DOMButton').text(e).tooltip(Game.difficulties[e].tooltip).attr(
      x: Game.difficulties[e].x * Game.width() / 2
      y: (Game.difficulties[e].y * 2 + 7) / 12 * Game.height()
      w: Game.width() / 2
      h: 50
    ).textFont(Game.difficultyFont).textColor(Game.difficulties[e].textColor).bind 'Click', ->
      console.log 'Chosen difficulty: ' + @text()
      Game.setDifficultyProperties @text()
      Crafty.scene 'MapSelection'
      return

  Crafty.e('DOMButton').text('Instructions').attr(
    x: 70
    y: Game.height() - 50
    w: 200
    h: 50
  ).tooltip('Click here for some instructions').bind 'Click', ->
    Crafty.scene 'Help', 'Difficulty'
    return

  Crafty.e('DOMButton').text('Credits').attr(
    x: 280
    y: Game.height() - 50
    w: 200
    h: 50
  ).tooltip('View the credits for this game ^^').bind 'Click', ->
    Crafty.scene 'Credits', 'Difficulty'
    return

  Crafty.e('SoundButton').attr
    x: 470
    y: Game.height() - 50
    w: 200
    h: 50
