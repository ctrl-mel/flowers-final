Crafty.c 'RestartLevel',
  init: ->
    @requires 'ConfirmOverlay'

    @infoTextContent = 'Really restart this level? You will restart at wave 1 with no towers!'
    @triggerName = 'RestartLevel'

    @showOverlay()
