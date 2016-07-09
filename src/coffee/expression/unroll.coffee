# Given:
# - A typed expression object.
# - The zero-based index of the item to extract.
# Returns a typed expression object which evaluates that item of the input typed
# expression object.  For instance, ([3, 6, 1] * -2), 1 would return (6 * -2).
module.exports = expressionUnroll = (expression, item) ->
    if expression.call
        expressionUnrollFunctions[expression.call] expression, item
    else
        expression

expressionUnrollFunctions = require "./unroll/functions"