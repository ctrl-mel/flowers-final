Crafty.scene 'Help', (targetScene) ->
  # FIXME use separate Text nodes instead of singular text, put into component (see credits scene for example)
  Crafty.e('2D, DOM, Text').attr(
    x: 10
    y: 10
    w: Game.width() - 20
    h: Game.height()
  ).text(
    '<p>Choose a difficulty and select a map. The game starts. You can click anywhere to build the selected tower type. ' +
      'You can find the selected tower type in the lower left of the screen (black is selected).' + '</p><p>' +
      'When you click on an already built tower you upgrade that tower. ' +
      'The costs and the current tower level are displayed on mouse over ' +
      'in the top right of the screen (Cost and Level).' + '</p><p>' +
      '<em><strong>There are two tower types to choose from, ' +
      'with the first one automatically selected:</strong></em>' + '</p><p>' +
      'The first tower type shoots leafs into all 4 directions, which damage the enemy on impact.' +
      'They have a limited range so build these towers near the path. Their range increases on higher levels.' + '</p><p>' +
      'The second tower shoots all over the map at a single random target.' +
      'The first tower you build of this type is relatively cheap,' +
      'but each one after the first one gets more and more expensive.' +
      'Upgrading, however, always costs the same.<br>' +
      'This tower gains a 2% chance to instantly kill an enemy on its highest level.' + '</p><p>' +
      'You have to start the first wave by clicking "Start". ' +
      'After that the waves come automatically, but you can start the next wave earlier by clicking "Next Wave" again.' + '</p><p>' +
      'You win if you finish all 15 waves, but you can challenge yourself ' +
      'and see how far you can get in endless mode after that.' + '</p>'
  ).textColor(Game.textColor).textFont Game.explanationFont

  Crafty.e('DOMButton').text('Back').attr(
    x: 280
    y: Game.height() - 50
    w: 200
    h: 50).tooltip('Go back to where you came from').bind 'Click', ->
      Crafty.enterScene targetScene, {dontRestartMenuMusic: true}
      return

  Crafty.e('SoundButton').attr
    x: 470
    y: Game.height() - 50
    w: 200
    h: 50
