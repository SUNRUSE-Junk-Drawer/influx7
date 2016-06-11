# Given an array of token objects representing an expression, returns either
# null if it does not represent a float literal, or the equivalent expression
# object if it does.  Will not parse a sign.
module.exports = expressionParseFloat = (tokens) ->
    isNumeric = (val) -> /^\d+$/.test tokens[val].token
    switch
        when tokens.length is 2 and (isNumeric 0) and tokens[1].token is "."
            primitive: "float"
            value: parseFloat "#{tokens[0].token}."
            starts: tokens[0].starts
            ends: tokens[1].ends
        when tokens.length is 2 and (isNumeric 1) and tokens[0].token is "."
            primitive: "float"
            value: parseFloat "0.#{tokens[1].token}"
            starts: tokens[0].starts
            ends: tokens[1].ends
        when tokens.length is 3 and (isNumeric 0) and tokens[1].token is "." and isNumeric 2
            primitive: "float"
            value: parseFloat "#{tokens[0].token}.#{tokens[2].token}"
            starts: tokens[0].starts
            ends: tokens[2].ends
        else null