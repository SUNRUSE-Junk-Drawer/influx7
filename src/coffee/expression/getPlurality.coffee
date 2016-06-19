# Given a typed expression object, returns the number of items in its return
# value.
# If a function call requires a specific plurality in its arguments, and it is
# not met, throws:
# - reason: "invalidPlurality"
# - starts: The number of characters between the start of the file and the start 
#           of the first token.
# - ends: The number of characters between the start of the file and the end of 
#   the last token.
# If a function call's arguments have ambiguous plurality (one or more arguments
# have a plurality greater than one, but not of the same value), throws:
# not met, throws:
# - reason: "inconsistentPlurality"
# - starts: The number of characters between the start of the file and the start 
#           of the first token.
# - ends: The number of characters between the start of the file and the end of 
#   the last token.
module.exports = expressionGetPlurality = (expression) ->
    if expression.call 
        functionPluralities[expression.call] (recurse arg for arg in expression.with), expression.starts, expression.ends
    else
        1

recurse = module.exports
functionPluralities = require "./functionPluralities"