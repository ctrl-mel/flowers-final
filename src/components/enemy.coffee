Crafty.c 'Enemy',
  init: ->
    @requires '2D, Canvas, Grid, Collision, PathWalker, Delay, Tooltip'
    @attr
      tooltipWidth: 150
      tooltipHeight: 30

    Game.enemyCount++

    @checkHits 'Bullet'
    @bind 'HitOn', (hitData) ->
      @hitWithDamage hitData[0].obj.damage
      hitData[0].obj.destroy()
      return

    that = this
    @delay (->
      that.tooltip (if that.tooltipTextBase then that.tooltipTextBase + ' with ' else '') + @health + ' HP'
      return
    ), 100, -1

    @bind 'TweenEnded', (actor) ->
      if that == actor
        Game.lifes -= @livesTaken or 1
        @kill false
        Crafty.audio.play 'LifeLost', 1
      return

    return

  hitWithDamage: (damage) ->
    if @health <= 0
      return

    @attr health: @health - damage
    if @health <= 0
      Game.money += @reward
      @kill()

    return

  kill: (playAudio) ->
    if playAudio == undefined
      playAudio = true
    if @dead
      return

    @dead = true
    Game.enemyCount--
    @destroy()
    Crafty.trigger 'EnemyKilled', this

    if playAudio
      Crafty.audio.play 'EnemyDead', 1, 0.15

    return
