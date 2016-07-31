# Given:
# - An untyped expression object.
# - A declarations object.
# Returns the same expression object, but inlined.  This means:
# - parentheses expression objects are replaced with their content.
# - return expression objects are replaced with their content.
# - reference expression objects are replaced with what they refer to.
# - let expression objects are replaced with their result.
# Additionally, references are validated.  This means that the following may be
# thrown:
# - If an identifier is not defined where it is used:
#   + reason: "undefinedReference"
#   + starts: The number of characters between the start of the file and the 
#             start of the token naming the identifier.
#   + ends: The number of characters between the start of the file and the end 
#           of the token naming the identifier.
# - If an identifier's name is already taken where it is declared:
#   + reason: "identifierNotUnique"
#   + starts: The number of characters between the start of the file and the 
#             start of the token naming the identifier the second time.
#   + ends: The number of characters between the start of the file and the end 
#           of the token naming the identifier the second time.

module.exports = expressionInline = (expression, declarations) -> switch
    when expression.call
        call: expression.call
        starts: expression.starts
        ends: expression.ends
        with: for arg in expression.with
            recurse arg, declarations
    when expression.parentheses then recurse expression.parentheses, declarations
    when expression.return then recurse expression.return, declarations
    when expression.reference then declarations[expression.reference] or throw unused = 
        reason: "undefinedReference"
        starts: expression.starts
        ends: expression.ends
    when expression.let
        if declarations[expression.declare.token]
            throw unused = 
                reason: "identifierNotUnique"
                starts: expression.declare.starts
                ends: expression.declare.ends
        else
            newDeclarations = {}
            for key, value of declarations
                newDeclarations[key] = value
            newDeclarations[expression.declare.token] = expression.as
            recurse expression.then, newDeclarations
    else expression

recurse = module.exports