# Exports an object where the keys are the names of typed functions, and the
# values are functions taking:
# - An array of integers specifying the plurality of the arguments.
# - The number of characters between the start of the file and the start of the
#   function call.
# - The number of characters between the start of the file and the end of the
#   function call.
# And returning the plurality of their output if not throwing an exception.

map = require "./functionPluralities/map"
concatenate = require "./functionPluralities/concatenate"
reduce = require "./functionPluralities/reduce"

module.exports = expressionFunctionPluralities = 
    concatenateInteger: concatenate

    addInteger: map
    subtractInteger: map
    multiplyInteger: map
    negateInteger: map
    
    equalInteger: map
    notEqualInteger: map
    lessThanInteger: map
    greaterThanInteger: map
    lessThanOrEqualInteger: map
    greaterThanOrEqualInteger: map
    
    concatenateFloat: concatenate

    addFloat: map
    subtractFloat: map
    multiplyFloat: map
    divideFloat: map
    negateFloat: map
    
    equalFloat: map
    notEqualFloat: map
    lessThanFloat: map
    greaterThanFloat: map
    lessThanOrEqualFloat: map
    greaterThanOrEqualFloat: map
    
    concatenateBoolean: concatenate
    
    equalBoolean: map
    notEqualBoolean: map
    
    notBoolean: map
    orBoolean: map
    andBoolean: map
    
    anyBoolean: reduce
    allBoolean: reduce
    
    sumInteger: reduce
    sumFloat: reduce
    productInteger: reduce
    productFloat: reduce