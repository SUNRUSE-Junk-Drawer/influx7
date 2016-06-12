# An object, where the keys are the names of typed functions, and the values
# are strings specifying the names of the types they return.
module.exports = expressionFunctionReturnTypes = 
    andBoolean: "boolean"
    orBoolean: "boolean"
    notBoolean: "boolean"
    
    addInteger: "integer"
    addFloat: "float"
    subtractInteger: "integer"
    subtractFloat: "float"
    multiplyInteger: "integer"
    multiplyFloat: "float"
    divideFloat: "float"
    negateInteger: "integer"
    negateFloat: "float"
    
    equalBoolean: "boolean"
    equalInteger: "boolean"
    equalFloat: "boolean"
    
    notEqualBoolean: "boolean"
    notEqualInteger: "boolean"
    notEqualFloat: "boolean"
    
    lessThanInteger: "boolean"
    lessThanFloat: "boolean"
    lessThanOrEqualInteger: "boolean"
    lessThanOrEqualFloat: "boolean"
    
    greaterThanInteger: "boolean"
    greaterThanFloat: "boolean"
    greaterThanOrEqualInteger: "boolean"
    greaterThanOrEqualFloat: "boolean"