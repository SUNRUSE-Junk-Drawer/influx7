# Given:
# - A typed expression object.
# - The zero-based index of the item to extract, or null to unroll all, but
#   call a concatenator at the root.
# Returns a typed expression object which evaluates that item of the input typed
# expression object.  For instance, ([3, 6, 1] * -2), 1 would return (6 * -2).
module.exports = expressionUnroll = (expression, item) ->
    if expression.call
        if item is null or item is undefined
            concatenator = expressionUnrollConcatenators[expressionGetReturnType expression]
            output = expressionUnrollFunctions[expression.call] expression, 0
            for item in [1...expressionGetPlurality expression]
                output = 
                    call: concatenator
                    with: [output, expressionUnrollFunctions[expression.call] expression, item]
                    starts: expression.starts
                    ends: expression.ends
            output
        else
            expressionUnrollFunctions[expression.call] expression, item
    else
        expression

expressionUnrollFunctions = require "./unroll/functions"
expressionGetPlurality = require "./getPlurality"
expressionGetReturnType = require "./getReturnType"
expressionUnrollConcatenators = require "./unroll/concatenators"