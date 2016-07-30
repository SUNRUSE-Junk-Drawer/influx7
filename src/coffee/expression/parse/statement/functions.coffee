# Exports an object where the keys are the names of statement types, and the
# values are functions to call to parse them, taking:
# - The token object which started the statement.
# - An array of token objects to parse.
# And returning the parsed expression object.  This should never return null;
# if the expression cannot be parsed, raise an exception.
module.exports = expressionParseStatementFunctions =
    return: (token, tokens) -> 
        if not tokens.length
            throw unused = 
                reason: "emptyExpression"
                starts: token.starts
                ends: token.ends
        else
            return: expressionParse tokens
            starts: token.starts
            ends: token.ends
    
expressionParse = require "./../../parse"