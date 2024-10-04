###
Wave component that handles all wave related stuff (starting waves, spawning enemies etc.)
###
Crafty.c 'Wave',
  init: ->
    @currentWave = Game.currentWave
    @gameStarted = false

    @automaticallyStartNextWave()

    return


  ###
  Cancel wave
  ###
  cancelWave: ->
    if @enemySpawnDelay
      @enemySpawnDelay.destroy()


  ###
  Automatically trigger starting next wave after all enemies are killed
  ###
  automaticallyStartNextWave: ->
    @lastWaveFinishedTriggered = false

    @bind 'EnterFrame', ->
      # wave is finished (but not the game): start next wave (if possible)
      if @isWaveFinished() and not @isLastWave() and @isNextWavePossible()
          Game.money += Game.moneyAfterWave
          @startNextWave()
          console.log 'Automatically started wave ' + @currentWave

      # game is finished: trigger last wave finished
      if @isWaveFinished() and @isLastWave() and not @lastWaveFinishedTriggered
        # trigger final wave finished to other places
        Crafty.trigger('LastWaveFinished')
        @lastWaveFinishedTriggered = true
        console.log('Last wave finished')

      return

    return


  isWaveFinished: ->
    Game.enemyCount == 0 and @spawnFinished and not @waveStarted


  isLastWave: ->
    @currentWave == Game.waves.current.length


  isNextWavePossible: ->
    Game.lifes > 0 and (Game.endless or not @isLastWave())


  ###
  Start next wave of enemies (either as configured for level or generated randomnly on endless)
  ###
  startNextWave: ->
    @spawnFinished = false
    @waveStarted = true

    # trigger (previous) wave finished to other places
    if @gameStarted
      Crafty.trigger 'WaveFinished', @currentWave

    @spawnEnemies()

    # play boss music on last (regular) wave
    if @currentWave == Game.waves.current.length - 1
      Crafty.audio.stop()
      Crafty.audio.play 'Boss', -1

    # increase current wave (also on Game.currentWave)
    @currentWave++
    Game.currentWave = @currentWave

    console.log('Current wave: ' + Game.currentWave)

    return


  ###
  Spawn the enemies (one after the other)
  ###
  spawnEnemies: ->
    enemies = @getEnemies()
    spawnedEnemies = 0
    that = @

    # spawn all enemies using delay (so each enemy is spawned after a delay)
    @enemySpawnDelay = Crafty.e('Delay').delay (->
      # catch error enemies[@spawnedEnemies] not defined (should not happen, but maybe wrongly configured)
      if not enemies[spawnedEnemies]
        console.error('An error occurred: enemies[spawnedEnemies] is empty, spawnedEnemies is at: ' + spawnedEnemies)
        console.dir(enemies)

      that.spawnEnemy enemies[spawnedEnemies]

      spawnedEnemies++

      # spawn finished
      if spawnedEnemies == enemies.length
        that.spawnFinished = true
        that.waveStarted = false
        console.log 'spawn finished'

      return
    ), @getSpawnInterval(), enemies.length - 1


  ###
  Spawn enemy
  ###
  spawnEnemy: (enemy)  ->
    # spawn enemy and animate him along the game path
    enemy = Crafty.e(enemy).at(Game.path.start.x, Game.path.start.y)
    enemy.animateAlong Game.path.getAsList(), enemy.speed

    # special handling for all waves after standard waves: increase health of enemy
    if @currentWave > Game.waves.current.length
      diff = @currentWave - (Game.waves.current.length)
      enemy.attr health: Math.floor((1 + diff * 0.05) * enemy.health + 5 * diff)
      console.log 'new health: ' + enemy.health


  ###
  Get spawn interval for enemies
  ###
  getSpawnInterval: ->
    # default spawn interval of 3 seconds
    interval = 3000

    # reduce spawn interval by 50ms every wave on endless mode
    if @currentWave > Game.waves.current.length
      interval = Math.max(200, 3000 - ((@currentWave - (Game.waves.current.length)) * 50))

    interval


  ###
  Get enemies for current wave (generate randomly on endless)
  ###
  getEnemies: ->
    if @currentWave < Game.waves.current.length
      Game.waves.current[@currentWave]
    else
      # TODO auto generate waves randomly, based on reward
      enemies = [
        'GreenDragon'
        'Orc'
      ]

      i = 0
      while i < @currentWave - (Game.waves.current.length)
        enemies.push if i % 10 == 4 then 'SilverDragon' else if i % 6 == 2 then 'GreenDragon' else if i % 4 == 0 then 'MightyWitch' else if i % 4 == 2 then 'FastKnight' else 'FastSquid'
        i++
      enemies.push 'GreenDragon'

      enemies
