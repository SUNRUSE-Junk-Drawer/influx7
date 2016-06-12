# Exports an object, where the keys are the names of operators, and the values
# are arrays of strings containing the symbols and keywords which refer to them.
module.exports = expressionOperatorTokens = {}
for operator, symbols of require "./operatorKeywords"
    module.exports[operator] = symbols.concat (require "./operatorSymbols")[operator]