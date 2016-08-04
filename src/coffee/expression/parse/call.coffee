# Given:
# - An array of parenthesized token objects.
# - The declarations object.
# If the tokens could be interpreted as a lambda expression call, returns the
# appropiate untyped expression object, otherwise, null.
# Throws exceptions if parseList fails on the argument list, or if 
# expressionParse fails when parsing either an argument or the lambda
# expression.
module.exports = expressionParseCall = (tokens, declarations) -> 
    if tokens.length > 1
        if tokens[tokens.length - 1].token is "("
            callLambda: expressionParse tokens[..tokens.length - 2], declarations
            with: expressionParseArgumentList tokens[tokens.length - 1], declarations
            starts: tokens[tokens.length - 1].starts
            ends: tokens[tokens.length - 1].ends
        else null
    else null

expressionParse = require "./../parse"
expressionParseArgumentList = require "./argumentList"