# Exports an object, where the keys are the names of operators, and the values
# are arrays of strings containing the keywords which refer to them.
module.exports = expressionParseOperatorKeywords = 
    not: ["not"]
    and: ["and"]
    or: ["or"]
    equal: ["is"]
    notEqual: ["isnt"]
    greaterThan: []
    greaterThanOrEqual: []
    lessThan: []
    lessThanOrEqual: []
    add: []
    subtract: []
    multiply: []
    divide: []
    negate: []