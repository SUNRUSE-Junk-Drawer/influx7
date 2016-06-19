# Exports an object where the keys are the names of untyped functions, and the
# values are functions taking:
# - An array of integers specifying the plurality of the arguments.
# - The number of characters between the start of the file and the start of the
#   function call.
# - The number of characters between the start of the file and the end of the
#   function call.
# And returning the plurality of their output if not throwing an exception.

map = require "./functionPluralities/map"
concatenate = require "./functionPluralities/concatenate"

module.exports = expressionFunctionPluralities = 
    concatenate: concatenate

    add: map
    subtract: map
    multiply: map
    divide: map
    negate: map
    
    equal: map
    notEqual: map
    lessThan: map
    greaterThan: map
    lessThanOrEqual: map
    greaterThanOrEqual: map
    
    not: map
    or: map
    and: map