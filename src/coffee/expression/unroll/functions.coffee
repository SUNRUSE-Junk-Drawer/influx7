# Exports an object, where keys are the names of unrolling functions, and values
# are their implementations, which given a typed expression object and the 
# zero-based index of the item to extract, return the typed expression object
# which evaluates it.  For instance, ([3, 6, 1] * -2), 1 would return (6 * -2).

map = require "./map"
concatenate = require "./concatenate"

module.exports = expressionUnrollFunctions =
    addInteger: map
    subtractInteger: map
    multiplyInteger: map
    negateInteger: map
    
    equalInteger: map
    notEqualInteger: map
    lessThanInteger: map
    lessThanOrEqualInteger: map
    greaterThanInteger: map
    greaterThanOrEqualInteger: map
    
    addFloat: map
    subtractFloat: map
    multiplyFloat: map
    divideFloat: map
    negateFloat: map
    
    equalFloat: map
    notEqualFloat: map
    lessThanFloat: map
    lessThanOrEqualFloat: map
    greaterThanFloat: map
    greaterThanOrEqualFloat: map
    
    equalBoolean: map
    notEqualBoolean: map
    notBoolean: map
    orBoolean: map
    andBoolean: map
    
    concatenateBoolean: concatenate
    concatenateInteger: concatenate
    concatenateFloat: concatenate