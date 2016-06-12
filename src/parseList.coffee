# Given:
# - an array of tokens to parse
# - a string to treat as a deliminator
# Attempts to parse it as a token-deliminated list.
# Expects that the deliminator is either a keyword, or registered as a splitting
# token.
# - If the list is valid or empty, returns an array of arrays of tokens denoting 
# the found groups.
# - If the placement of deliminators creates an empty group, throws:
#   + reason: "emptyGroup"
#   + starts: The number of characters between the start of the file and the 
#             start of the first token.
#   + ends: The number of characters between the start of the file and the end 
#           of the last token.
module.exports = parseCommaDeliminatedList = (tokens, deliminator) -> 
    if not tokens.length 
        []
    else
        output = [
            tokens: []
        ]
        
        for token in tokens
            if token.token is deliminator
                if not output[output.length - 1].tokens.length
                    throw unused = 
                        reason: "emptyGroup"
                        starts: if output.length is 1 then token.starts else output[output.length - 1].startedBy.starts
                        ends: token.ends
                output.push
                    startedBy: token
                    tokens: []
            else
                output[output.length - 1].tokens.push token
                
        if output.length > 1 and not output[output.length - 1].tokens.length
            throw unused = 
                reason: "emptyGroup"
                starts: output[output.length - 1].startedBy.starts
                ends: output[output.length - 1].startedBy.ends
        
        group.tokens for group in output