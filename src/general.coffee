if !console
  console = log: ->

# create empty Game object (gets filled by files in src/assets, src/game, src/waves)
window.Game = {
  assets: []
  waves: [
    current: {}
  ]
}
