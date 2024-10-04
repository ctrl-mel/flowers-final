###
Wave start indicator that indicates a start of a new wave by making shooting flower towers shoot
###
Crafty.c 'WaveStartIndicator',
  init: ->
    @requires 'Delay'

    # make all flower towers shoot to indicate new wave
    flowerTowers = Crafty('FlowerTower')
    i = 0
    if flowerTowers.length > 0
      @delay (->
        flowerTowers.get(i).shoot()
        i++
        return
      ), 500, flowerTowers.length - 1
