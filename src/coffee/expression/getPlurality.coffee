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
        plurality = functionPluralities[expression.call] 
        switch plurality
            when "concatenate"
                expression.with.reduce ((t, e) -> t + recurse e), 0
            when "map"
                pluralities = (recurse argument for argument in expression.with)
                firstNonOne = 1
                for plurality in pluralities
                    if plurality is 1 then continue
                    firstNonOne = plurality
                    break
                if firstNonOne is 1 then return 1
                for plurality in pluralities
                    if plurality is 1 then continue
                    if plurality is firstNonOne then continue
                    throw unused =
                        reason: "inconsistentPlurality"
                        starts: expression.starts
                        ends: expression.ends
                firstNonOne
            else
                for argument in expression.with
                    switch recurse argument
                        when plurality.input then continue
                        when 1 then continue
                        else throw unused =
                            reason: "invalidPlurality"
                            starts: expression.starts
                            ends: expression.ends
                plurality.output
    else
        1

recurse = module.exports
functionPluralities = require "./functionPluralities"