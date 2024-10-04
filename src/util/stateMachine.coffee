###*
# State machine which allows putting, transitioning and getting current state.
#
# Created by Oliver on 06.08.2015.
###

class StateMachine
  constructor: ->
    @states = {}
    @current = undefined
    @history = []

    return


  setStart: (input) ->
    @current = input
    @history.push @current

    return


  produceFromState: (fromState, input) ->
    if input == undefined or input == null
      fromState
    else if typeof input == 'object' or typeof input == 'array'
      fromState + '_$$_' + JSON.stringify(input)
    else
      fromState + '_$$_' + input


  put: (fromState, input, toState, output, condition) ->
    @states[@produceFromState(fromState, input)] =
      state: toState
      output: output
      condition: condition

    return


  get: (index) ->
    if index == undefined
      @current
    else
      # get state at the given index position (negative values wrap around to the end,
      # like history[0], history[1], history[2], history [-2], history[-1] could be the history in correct order
      @history[(@history.length + index) % @history.length]


  resetBy: (index) ->
    previous = @current
    i = 0
    while i < index
      @current = @history.pop()
      i++

    previous


  transition: (input) ->
    result = @states[@produceFromState(@current, input)]

    if not result
      result = @states[@produceFromState(@current, undefined)]

    if result != undefined and (result.condition == undefined or result.condition.call())
      @current = result.state
      @history.push @current

      result
    else
      undefined


  ###*
  # Returns the same output as StateMachine.transition, but without the side effects.
  # @param input
  # @returns {*}
  ###
  simulate: (input) ->
    result = @states[@produceFromState(@current, input)]
    if !result
      result = @states[@produceFromState(@current, undefined)]
    if result != undefined and (result.condition == undefined or result.condition.call())
      result
    else
      undefined


# make this class known outside
window.StateMachine = StateMachine
