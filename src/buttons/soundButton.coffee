Crafty.c 'SoundButton', init: ->
  @requires 'DOMButton'

  if Crafty.storage('muted')
    Crafty.audio.mute()
    @text 'Sound: Off'
    @tooltip 'Sound is off. Click to turn it on.'
  else
    @text 'Sound: On'
    @tooltip 'Sound is on. Click to turn it off.'

  @bind 'Click', ->
    if Crafty.audio.muted
      Crafty.audio.unmute()
      @text 'Sound: On'
      @tooltip 'Sound is on. Click to turn it off.'
      Crafty.storage 'muted', false
    else
      Crafty.audio.mute()
      @text 'Sound: Off'
      @tooltip 'Sound is off. Click to turn it on.'
      Crafty.storage 'muted', true
    return

  return
