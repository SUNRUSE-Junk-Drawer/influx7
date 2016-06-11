# Given:
# - An array of token objects representing a binary operator expression.
# - An array of strings specifing the operators which should be found.
# Returns the equivalent expression object if one is found, otherwise null.
# Ignores any symbol following an operator as it assumed to be a unary operator.
# Could throw exceptions; recurses to expressionParse for the left and right
# sides.
module.exports = expressionParseBinary = (tokens, level) -> 
    if tokens.length > 2
        for token, i in tokens
            if i is 0 then continue
            if i is (tokens.length - 1) then continue
            followingAnotherSymbol = false
            for operator, symbols of expressionParseOperatorTokens
                for symbol in symbols 
                    if tokens[i - 1].token is symbol then followingAnotherSymbol = true
            if not followingAnotherSymbol
                for operator in level
                    if token.token in expressionParseOperatorTokens[operator]
                        return unused =
                            call: operator
                            with: [
                                expressionParse tokens[...i]
                                expressionParse tokens[i + 1...]
                            ]
                            starts: tokens[i].starts
                            ends: tokens[i].ends
    null
        
expressionParse = require "./../parse"
expressionParseOperatorTokens = require "./operatorTokens"