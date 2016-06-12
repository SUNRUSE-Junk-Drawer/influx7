# Given an untyped expression object:
# - If no match for a function call expression object can be found, throws:
#   + reason: "invalidExpression"
#   + starts: The number of characters between the start of the file and the 
#             start of the first token.
#   + ends: The number of characters between the start of the file and the end 
#           of the last token.
# - Otherwise, returns the equivalent typed expression object.
module.exports = expressionTypeCheck = (expression) -> 
    if expression.call
        args = (recurse arg for arg in expression.with)
        argTypes = (expressionGetReturnType arg for arg in args)
        func = null
        for option, parameters of expressionFunctionParameters[expression.call]
            if parameters.length isnt argTypes.length then continue
            func = option
            for arg, i in argTypes
                if parameters[i] is arg then continue
                func = null
                break
            if func then break
        if not func then throw unused = 
            reason: "typeCheckFailed"
            starts: expression.starts
            ends: expression.ends
        call: func
        with: args
        starts: expression.starts
        ends: expression.ends
    else
        expression

recurse = module.exports
expressionFunctionParameters = require "./functionParameters"
expressionGetReturnType = require "./getReturnType"