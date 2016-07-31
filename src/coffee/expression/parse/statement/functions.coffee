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
    let: (token, tokens) ->
        if tokens.length is 0 then throw unused =
            reason: "identifierExpected"
            starts: token.starts
            ends: token.ends
        if not isIdentifier tokens[0].token then throw unused =
            reason: "identifierInvalid"
            starts: tokens[0].starts
            ends: tokens[0].ends
        if tokens.length is 1 then throw unused =
            reason: "emptyExpression"
            starts: token.starts
            ends: tokens[0].ends
        next = expressionParseStatementFindNext tokens[1..]
        if not next then throw unused =
            reason: "returnExpected"
            starts: tokens[1].starts
            ends: tokens[tokens.length - 1].ends
        if not next.before.length then throw unused =
            reason: "emptyExpression"
            starts: token.starts
            ends: tokens[0].ends
        let: token
        declare: tokens[0]
        as: expressionParse next.before
        then: next.statementFunction next.statement, next.after
expressionParse = require "./../../parse"
expressionParseStatementFindNext = require "./findNext"
isIdentifier = require "./../../../isIdentifier"