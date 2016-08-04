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
            class: "Operator"
        ]
        for argument in expression.with
            output = output.concat recurse argument
        output
    when expression.return then [
        starts: expression.starts
        ends: expression.ends
        class: "Statement"
    ].concat recurse expression.return
    when expression.parentheses
        before = [
            starts: expression.starts
            ends: expression.starts
            class: "Parenthesis"
        ]
        between = recurse expression.parentheses
        after = [
            starts: expression.ends
            ends: expression.ends
            class: "Parenthesis"
        ]
        before
            .concat between
            .concat after
    when expression.reference then [
        starts: expression.starts
        ends: expression.ends
        class: "Identifier"
    ]
    when expression.let
        before = [
                starts: expression.let.starts
                ends: expression.let.ends
                class: "Statement"
            ,
                starts: expression.declare.starts
                ends: expression.declare.ends
                class: "Identifier"
        ]
        before
            .concat recurse expression.as
            .concat recurse expression.then
    when expression.body
        (for parameter in expression.parameters
            class: "Identifier"
            starts: parameter.starts
            ends: parameter.ends
        ).concat [
            class: "Statement"
            starts: expression.starts
            ends: expression.ends
        ].concat recurse expression.body
    when expression.callLambda
        output = (recurse expression.callLambda).slice()
        output.push
            class: "Parenthesis"
            starts: expression.starts
            ends: expression.starts
        for argument in expression.with
            for token in recurse argument
                output.push token
        output.push
            class: "Parenthesis"
            starts: expression.ends
            ends: expression.ends
        output
    
recurse = module.exports