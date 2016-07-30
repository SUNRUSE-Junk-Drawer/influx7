# Given an array of parenthesized token objects possibly representing a
# reference to a declaration or parameter, if it appears to, returns the
# equivalent expression object, otherwise null.
# Please note that this does not validate that the reference exists.
module.exports = expressionParseReference = (tokens) -> switch
    when tokens.length isnt 1 then null
    when not isIdentifier tokens[0].token then null
    else
        reference: tokens[0].token
        starts: tokens[0].starts
        ends: tokens[0].ends
        
isIdentifier = require "./../../isIdentifier"