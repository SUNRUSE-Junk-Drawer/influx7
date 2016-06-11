# Exports an object, where the keys are the names of operators, and the values
# are arrays of strings containing the symbols which refer to them.
module.exports = expressionParseOperatorSymbols = 
    not: ["!"]
    and: ["&", "&&"]
    or: ["|", "||"]
    equal: ["=", "=="]
    notEqual: ["<>", "!="]
    greaterThan: [">"]
    greaterThanOrEqual: [">="]
    lessThan: ["<"]
    lessThanOrEqual: ["<="]
    add: ["+"]
    subtract: ["-"]
    multiply: ["*"]
    divide: ["/"]
    negate: ["-"]