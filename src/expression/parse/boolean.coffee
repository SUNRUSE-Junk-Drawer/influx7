# Given an array of token objects representing an expression, returns either
# null if it does not represent a boolean literal, or the equivalent expression
# object if it does.
module.exports = expressionParseBoolean = (tokens) -> 
    if tokens.length isnt 1
        null
    else
        switch tokens[0].token
            when "false"
                primitive: "boolean"
                value: false
                starts: tokens[0].starts
                ends: tokens[0].ends
            when "true"
                primitive: "boolean"
                value: true
                starts: tokens[0].starts
                ends: tokens[0].ends