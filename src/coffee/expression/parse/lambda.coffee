# Given: 
# - An array of token objects representing an expression.
# Returns either null if it does not represent a lambda, or the equivalent 
# expression object if it does.
# If multiple lambda symbols are present, the first is taken and the subsequent
# will be parsed when recursing through to the body.
# If the tokens contain the lambda symbol but cannot be parsed as a lambda,
# an object is thrown containing:
# - reason: A string describing the problem, of:
#   + expectedExpression: Nothing follows "->".
#   + noParameters: Nothing precedes "->".
#   + duplicateParameters: Two or more parameters share names.
# - starts: The number of characters between the start of the code and the start
#           of the lambda symbol.
# - ends: The number of characters between the start of the code and the end
#           of the lambda symbol.

module.exports = expressionParseLambda = (tokens) ->
    for token, i in tokens
        if token.token isnt "->" then continue
        parameters = tokens[...i]
        body = tokens[i + 1..]
        for parameter, i in parameters
            for parameter2, j in parameters
                if i is j then continue
                if parameter.token is parameter2.token then throw unused = 
                    reason: "duplicateParameters"
                    starts: parameter2.starts
                    ends: parameter2.ends
        if not parameters.length then throw unused = 
            reason: "noParameters"
            starts: token.starts
            ends: token.ends
        if not body.length then throw unused = 
            reason: "emptyExpression"
            starts: token.starts
            ends: token.ends
        return unused = 
            parameters: parameters
            body: expressionParse body
            starts: token.starts
            ends: token.ends
    null

expressionParse = require "./../parse"
isIdentifier = require "./../../isIdentifier"