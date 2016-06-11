# Given an array of token objects representing an expression, returns either
# null if it does not represent an integer literal, or the equivalent expression
# object if it does.  Will not parse a sign.
module.exports = expressionParseInteger = (tokens) ->
    isNumeric = (val) -> /^\d+$/.test tokens[val].token
    if tokens.length is 1 and isNumeric 0
        primitive: "integer"
        value: parseInt tokens[0].token
        starts: tokens[0].starts
        ends: tokens[0].ends
    else null