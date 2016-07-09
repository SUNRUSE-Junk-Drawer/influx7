# Exports an object, where the keys are the names of typed functions and the
# values are JavaScript functions implementing them for constant inputs.

ensureNonNegativeZero = (a) -> if a is -0 then 0 else a

module.exports = expressionFunctionImplementations = 
    equalBoolean: (a, b) -> a is b
    notEqualBoolean: (a, b) -> a isnt b
    
    equalInteger: (a, b) -> a is b
    notEqualInteger: (a, b) -> a isnt b
    lessThanInteger: (a, b) -> a < b
    lessThanOrEqualInteger: (a, b) -> a <= b
    greaterThanInteger: (a, b) -> a > b
    greaterThanOrEqualInteger: (a, b) -> a >= b
    
    equalFloat: (a, b) -> a is b
    notEqualFloat: (a, b) -> a isnt b
    lessThanFloat: (a, b) -> a < b
    lessThanOrEqualFloat: (a, b) -> a <= b
    greaterThanFloat: (a, b) -> a > b
    greaterThanOrEqualFloat: (a, b) -> a >= b
    
    andBoolean: (a, b) -> a and b
    orBoolean: (a, b) -> a or b
    notBoolean: (a) -> not a
    
    addFloat: (a, b) -> ensureNonNegativeZero a + b
    subtractFloat: (a, b) -> ensureNonNegativeZero a - b
    multiplyFloat: (a, b) -> ensureNonNegativeZero a * b
    divideFloat: (a, b) -> ensureNonNegativeZero a / b
    negateFloat: (a) -> ensureNonNegativeZero -a
    
    addInteger: (a, b) -> ensureNonNegativeZero a + b
    subtractInteger: (a, b) -> ensureNonNegativeZero a - b
    multiplyInteger: (a, b) -> ensureNonNegativeZero a * b
    negateInteger: (a) -> ensureNonNegativeZero -a
    
    concatenateBoolean: (a, b) -> a.concat b
    concatenateInteger: (a, b) -> a.concat b
    concatenateFloat: (a, b) -> a.concat b