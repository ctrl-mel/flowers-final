Crafty.c 'OverwriteSavegame',
  init: ->
    @requires 'ConfirmOverlay'

    @infoTextContent = 'Starting a new game will overwrite your already saved game. Continue?'
    @triggerName = 'OverwriteSavegameConfirmed'
