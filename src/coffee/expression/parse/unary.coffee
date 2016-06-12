# Given:
# - An array of token objects representing a unary operator expression.
# - An array of strings specifing the operators which should be found.
# Returns the equivalent untyped expression object if one is found, otherwise 
# null.
# Could throw exceptions; recurses to expressionParse for the operand.
module.exports = expressionParseUnary = (tokens, level) -> 
    if tokens.length > 1
        for operator in level
            if tokens[0].token in expressionParseOperatorTokens[operator]
                return unused =
                    call: operator
                    with: [expressionParse tokens[1..]]
                    starts: tokens[0].starts
                    ends: tokens[0].ends
    null
        
expressionParse = require "./../parse"
expressionParseOperatorTokens = require "./operatorTokens"