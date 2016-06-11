# Given an array of token objects to parse:
# - If it does not represent a set of parentheses, returns null.
# - If the parentheses contain tokens, recurses through expressionParse and
#   returns the result.
# - If the parentheses contain no tokens, throws an object containing:
#   + reason: "emptyExpression"
#   + starts: The number of characters between the start of the file and the 
#             start of the first token.
#   + ends: The number of characters between the start of the file and the end 
#           of the last token.
# - If recursing to expressionParse returns null, throws an object containing:
#   + reason: "invalidExpression"
#   + starts: The number of characters between the start of the file and the 
#             start of the first token.
#   + ends: The number of characters between the start of the file and the end 
#           of the last token.
module.exports = expressionParseParentheses = (tokens) -> switch
    when tokens.length isnt 1 then null
    when tokens[0].token isnt "(" then null
    when not tokens[0].children.length then throw unused = 
        reason: "emptyExpression"
        starts: tokens[0].starts
        ends: tokens[0].ends
    else 
        result = expressionParse tokens[0].children
        if result
            result
        else throw unused = 
            reason: "invalidExpression"
            starts: tokens[0].starts
            ends: tokens[0].ends            

expressionParse = require "./../parse"