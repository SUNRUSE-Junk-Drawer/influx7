# Given an array of token objects containing:
# - token: A string containing the found token.  (lower cased)
# - starts: The number of characters between the start of the file and the start
#           of the token.
# Returns an array of token objects parenthesized based on the parentheses 
# module, containing:
# - token: A string containing the found token.  (lower cased)
#          When representing a set of parentheses, the opening token.
# - starts: The number of characters between the start of the file and the start
#           of the token.
# - ends: The number of characters between the start of the file and the end of 
#         the token.
# - children: When non-null, the token represents a set of parantheses and
#             contains an array of more of these objects.
# Throws:
# - reason: A string specifying the error which was encountered, of:
#   + unclosedParentheses
#   + unopenedParantheses
# - starts: The number of characters between the start of the file and the start
#           of the token which triggered the error.
# - ends: The number of characters between the start of the file and the end of 
#         the token which triggered the error.
module.exports = tokenizeParenthesize = (tokens) -> 
    tokens = tokens.slice()
    recurse = (openerToken, openerCloser) ->
        output = []
        endedAt = if openerToken then openerToken.starts + openerToken.token.length - 1 else null
        while tokens.length
            next = tokens.shift()
            endedAt = next.starts + next.token.length - 1
            if next.token is openerCloser
                return unused = 
                    children: output
                    ends: endedAt
            found = false
            for opener, closer of parentheses
                if next.token is opener
                    recursed = recurse next, closer
                    output.push
                        token: next.token
                        starts: next.starts
                        ends: recursed.ends
                        children: recursed.children
                    endedAt = recursed.ends
                    found = true
                    break
                if next.token is closer then throw unused = 
                    reason: "unopenedParentheses"
                    starts: next.starts
                    ends: endedAt
            if not found
                output.push
                    token: next.token
                    starts: next.starts
                    ends: endedAt
        if openerToken isnt null then throw unused = 
            reason: "unclosedParentheses"
            starts: openerToken.starts
            ends: endedAt
        children: output
    (recurse null, null).children

parentheses = require "./parentheses"