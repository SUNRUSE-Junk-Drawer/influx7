# Given either a typed or untyped expression object, returns a flat array of 
# objects describing all expression objects within it, containing:
# - starts: The number of characters between the start of the code and this
#           token.
# - ends: The number of characters between the start of the code and the end of 
#         this token.
# - class: A string describing the token; see ./guessClass.

# TODO: This currently cannot recreate parentheses as they are not included in
# the expression.

module.exports = editorCompilerGenerateSyntaxHighlightingForExpression = (expression) -> switch
    when expression.primitive then [
        starts: expression.starts
        ends: expression.ends
        class: "Literal"
    ]
    when expression.call
        output = [
            starts: expression.starts
            ends: expression.ends
            class: "Function"
        ]
        for argument in expression.with
            output = output.concat recurse argument
        output
    
recurse = module.exports