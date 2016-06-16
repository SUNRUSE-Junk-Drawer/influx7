# Exports an object, where the keys are the names of statements, and the values
# are arrays of strings containing the symbols and keywords which refer to them.
module.exports = statementOperatorTokens = {}
for operator, symbols of require "./symbols"
    module.exports[operator] = symbols.concat (require "./keywords")[operator]