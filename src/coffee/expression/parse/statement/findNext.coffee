# Given an array of token objects, if a statement is referenced inside, returns:
# - before: An array of the token objects before the first reference to a 
#           statement.
# - statement: The token object which declared a new statement.
# - after: An array of the the token objects after the first reference to a 
#          statement.
# Otherwise returns null.
module.exports = expressionParseStatementFindNext = (tokens) ->
    for token, i in tokens
        if not Object.prototype.hasOwnProperty.call expressionParseStatementFunctions, token.token then continue
        return unused =
            before: tokens[...i]
            statement: token
            statementFunction: expressionParseStatementFunctions[token.token]
            after: tokens[i + 1..]
    null

expressionParseStatementFunctions = require "./functions"