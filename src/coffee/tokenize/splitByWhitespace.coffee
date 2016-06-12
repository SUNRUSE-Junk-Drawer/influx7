# Given a string describing source code, splits it by whitespace (newline, etc.)
# and returns an array of objects describing the found tokens containing:
# - token: A string containing the found token.  (lower cased)
# - starts: The number of characters between the start of the file and the start
#           of the token.
module.exports = tokenizeSplitByWhitespace = (input) ->
    output = []
    token = tokenStarts = null
    finishToken = ->
        if token isnt null
            output.push
                token: token
                starts: tokenStarts
            token = null
    for character, index in input.toLowerCase()
        if character.trim() is ""
            finishToken()
        else
            if token is null
                token = character
                tokenStarts = index
            else
                token += character
    finishToken()
    output