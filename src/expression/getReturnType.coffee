# Given a typed expression object, returns a string specifying the type it
# evaluates to.
module.exports = expressionGetReturnType = (expression) -> 
    expression.primitive or expressionFunctionReturnTypes[expression.call]

expressionFunctionReturnTypes = require "./functionReturnTypes"