Crafty.c 'WaveButton',
  init: ->
    @requires 'DOMButton, Grid, Delay'
    @attr
      w: 150
      tooltipWidth: 350
      clickEnabled: true

    @text 'Start'
    @tooltip 'Starts the next wave of enemies. Click here once you placed your towers.'
    @textFont Game.waveFont

    @blinkBeforeStart()
    @startNextWaveOnClick()

    return


  blinkBeforeStart: ->
    highlighted = false

    @delay (->
      if !@wave.waveStarted
        if highlighted
          @textColor Game.textColor
        else
          @textColor Game.highlightColor
        highlighted = !highlighted
      return
    ), 1000, -1

    return


  startNextWaveOnClick: ->
    @bind 'Click', ->
      if @clickEnabled
        @clickEnabled = false
        @text 'Next Wave'
        @textColor Game.disabledColor
        @tooltip 'Button currently disabled.'

        if @wave.gameStarted
          Game.money += Game.moneyAfterWave

        @wave.startNextWave()
        @wave.gameStarted = true

        @delay (->
          @clickEnabled = true
          @textColor Game.textColor
          @tooltip 'Start next wave early to get wave finished bonus gold.'
          return
        ), 10000, 0

      return

    return
