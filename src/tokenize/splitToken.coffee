# Given a token object containing:
# - token: A string containing the found token.  (lower cased)
# - starts: The number of characters between the start of the file and the start
#           of the token.
# Splits it based on the symbols defined in the symbols module, prioritizing the
# longest over the shortest and returning an array of token objects also
# containing:
# - token: A string containing the found token.  (lower cased)
# - starts: The number of characters between the start of the file and the start
#           of the token.
module.exports = tokenizeSplitToken = (input) ->
    sortedSymbols = symbols.slice().sort (a, b) -> b.length - a.length
    recurse = (token) ->
        for symbol in sortedSymbols
            index = token.token.indexOf symbol
            if index is -1 then continue
            allSubtokens = []
            if index > 0
                for subtoken in (recurse
                        token: (token.token.slice 0, index)
                        starts: token.starts
                    )
                    allSubtokens.push subtoken
            allSubtokens.push
                token: symbol
                starts: token.starts + index
            if index < token.token.length - symbol.length
                for subtoken in (recurse
                        token: (token.token.slice index + symbol.length)
                        starts: token.starts + index + symbol.length
                    )
                    allSubtokens.push subtoken                
            return allSubtokens
        [token]
    recurse input
    
symbols = require "./symbols"