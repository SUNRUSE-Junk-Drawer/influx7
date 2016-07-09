# A function unroll function (see ./functions) which implements "concatenate" 
# plurality; two arguments with (possibly differing) plurality are concatenated
# into a single value.
# For unrolling, the left or right argument must be determined based on the
# item index:
# (a concatenate function) [4, 8], [10, 19, 21]
# index 0: 4
# index 1: 8
# index 2: 10
# index 3: 19
# index 4: 21
module.exports = expressionUnrollConcatenate = (expression, item) ->
    plurality = expressionGetPlurality expression.with[0]
    if item < plurality
        expressionUnroll expression.with[0], item
    else
        expressionUnroll expression.with[1], item - plurality

expressionGetPlurality = require "./../getPlurality"
expressionUnroll = require "./../unroll"