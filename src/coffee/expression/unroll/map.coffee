# A function unroll function (see ./functions) which implements "map" plurality;
# the underlying function does not support plurality, so if the arguments are
# plural, it should be called for each item in them.
# [3, 4] * [10, 8] = (3 * 10), (4 * 8)
# [3, 4] * 7 = (3 * 4), (4 * 7)
module.exports = expressionUnrollMap = (expression, item) ->
    call: expression.call
    with: for arg in expression.with
        if (expressionGetPlurality arg) is 1
            expressionUnroll arg, 0
        else
            expressionUnroll arg, item
    starts: expression.starts
    ends: expression.ends

expressionGetPlurality = require "./../getPlurality"
expressionUnroll = require "./../unroll"