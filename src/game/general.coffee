Game.map_grid =
  width: 25
  height: 15
  tile:
    width: 32
    height: 32
  pathMinLength: 70
  pathMaxLength: 80

Game.options =
  bulletImages: true
  music: true
  soundEffects: true

Game.speedup = 1


Game.setGeneralProperties = ->
  Game.endless = false
  Game.enemyCount = 0
  Game.currentWave = 0
  Game.selectedTower = 'SniperTower'
  Game.sniperTowerInitial = @towers['SniperTower']
  Game.towerMap = new Array(Game.map_grid.width)

  # generate tower map (used for saving/loading placed towers)
  x = 0
  while x < Game.map_grid.width
    Game.towerMap[x] = new Array(Game.map_grid.height)
    y = 0
    while y < Game.map_grid.height
      Game.towerMap[x][y] =
        name: ''
        level: 0
      y++
    x++

  return


Game.setDifficultyProperties = (difficulty) ->
  config = Game.difficulties[difficulty]

  Game.difficulty = difficulty
  Game.money = config.money
  Game.lifes = config.lifes
  Game.moneyAfterWave = config.moneyAfterWave
  Game.towers =
    'FlowerTower': config.towers.FlowerTower
    'SniperTower': config.towers.SniperTower
    'SniperTowerUpgrade': config.towers.SniperTowerUpgrade

  return


Game.width = -> @map_grid.width * @map_grid.tile.width
Game.height = -> @map_grid.height * @map_grid.tile.height
