# Given:
# - An array of token objects to parse.
# Returns null if no statement can be parsed from the token objects, otherwise
# the parsed untyped expression object.
module.exports = expressionParseStatement = (tokens) -> 
    next = expressionParseStatementFindNext tokens
    switch
        when next is null then null
        when next.before.length then null
        else next.statementFunction next.statement, next.after

expressionParseStatementFindNext = require "./statement/findNext"