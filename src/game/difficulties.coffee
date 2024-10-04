Game.difficulties =
    'Easy':
      textColor: 'green'
      tooltip: '100 lifes, normal prices, lots of money'
      x: 0
      y: 0
      money: 60
      lifes: 10
      moneyAfterWave: 20
      towers:
        'FlowerTower': 10
        'SniperTower': 20
        'SniperTowerUpgrade': 20

    'Normal':
      textColor: 'yellow'
      tooltip: '40 lifes, normal prices, normal amount of money'
      x: 1
      y: 0
      money: 30
      lifes: 10
      moneyAfterWave: 10
      towers:
        'FlowerTower': 10
        'SniperTower': 20
        'SniperTowerUpgrade': 20

    'Hard':
      textColor: 'red'
      tooltip: '15 lifes, normal prices, less money after waves'
      x: 0
      y: 1
      money: 25
      lifes: 10
      moneyAfterWave: 5
      towers:
        'FlowerTower': 12
        'SniperTower': 20
        'SniperTowerUpgrade': 25

    'Impossible':
      textColor: '#880044'
      tooltip: '10 lifes, higher prices, no money after waves'
      x: 1
      y: 1
      money: 20
      lifes: 10
      moneyAfterWave: 0
      towers:
        'FlowerTower': 15
        'SniperTower': 25
        'SniperTowerUpgrade': 50
