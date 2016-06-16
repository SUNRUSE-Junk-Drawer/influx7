# Given an array of tokens, returns an object containing:
# - statement: If a statement keyword is present, an array of the tokens 
#              preceding it, otherwise the input.
# - next: If a statement keyword is present, an array containing it and the 
#         trailing tokens, otherwise an empty array.
module.exports = statementParseFindNext = (tokens) -> 
    for token, firstStatement in tokens
        if statementParseStatements[token.token] then break
    statement: tokens[...firstStatement]
    next: tokens[firstStatement...]
    
statementParseStatements = require "./statements"