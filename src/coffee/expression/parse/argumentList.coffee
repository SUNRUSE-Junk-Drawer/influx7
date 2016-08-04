# Given:
# - A parenthesis token object.
# - A declaration object.
# Returns an array of the comma-deliminated untyped expression objects inside
# the token.  See expressionParse and parseList for exceptions throwable other
# than (when empty):
# - reason: "emptyExpression"
# - starts: The number of characters between the start of the file and the start
#           of the first token.
# - ends: The number of characters between the start of the file and the end of 
#         the last token.
module.exports = expressionParseArgumentList = (token, declarations) -> 
    if not token.children.length then throw unused = 
        reason: "emptyExpression"
        starts: token.starts
        ends: token.ends
    for argument in parseList token.children, ","
        expressionParse argument, declarations

parseList = require "./../../parseList"
expressionParse = require "./../parse"