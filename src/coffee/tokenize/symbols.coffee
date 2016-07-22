# An array of strings representing symbols which should split tokens.
module.exports = tokenizeSymbols = [",", ".", ":"]
    .concat (opener for opener, closer of require "./parentheses")
    .concat (closer for opener, closer of require "./parentheses")

for operator, symbols of require "./../expression/parse/operatorSymbols"
    for symbol in symbols
        module.exports.push symbol
        
for statement, symbols of require "./../statement/parse/symbols"
    for symbol in symbols
        module.exports.push symbol
        
# Remove duplicates.
for character, index in module.exports
    removals = []
    for otherCharacter, otherIndex in module.exports
        if character isnt otherCharacter then continue
        if otherIndex <= index then continue
        removals.push otherIndex
    for otherIndex in removals.reverse()
        module.exports.splice otherIndex, 1