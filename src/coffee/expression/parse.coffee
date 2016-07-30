# Given an array of token objects to parse:
# - If the tokens represent a syntactically valid expression, the 
#   untyped expression object parsed.
# - Otherwise, throws:
#   + reason: "invalidExpression"
#   + starts: The number of characters between the start of the file and the 
#             start of the first token.
#   + ends: The number of characters between the start of the file and the end 
#           of the last token.
# Assumes that the argument is not empty, as if it was, it would not know which
# range of characters to include in the exception.
# Recurses through to expressionParseParentheses/expressionParseStatement; could 
# throw other exceptions.
module.exports = expressionParse = (tokens) ->
    result = (expressionParseReference tokens) or (expressionParseStatement tokens) or (expressionParseParentheses tokens) or (expressionParseFloat tokens) or (expressionParseInteger tokens) or (expressionParseBoolean tokens)
    if result
        result
    else
        for level in expressionParseOperatorPrecedence
            result = expressionParseUnary tokens, level.unary
            if result then return result
            result = expressionParseBinary tokens, level.binary
            if result then return result
        throw unused = 
            reason: "invalidExpression"
            starts: tokens[0].starts
            ends: tokens[tokens.length - 1].ends   
    
expressionParseReference = require "./parse/reference"
expressionParseStatement = require "./parse/statement"
expressionParseParentheses = require "./parse/parentheses"
expressionParseUnary = require "./parse/unary"
expressionParseBinary = require "./parse/binary"
expressionParseBoolean = require "./parse/boolean"
expressionParseInteger = require "./parse/integer"
expressionParseFloat = require "./parse/float"
expressionParseOperatorPrecedence = require "./parse/operatorPrecedence"