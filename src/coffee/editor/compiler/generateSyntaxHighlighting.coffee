# Given:
# - A string containing the source code.
# - An array of objects describing known parts of the source code, containing:
#   + starts: The number of characters between the start of the source code and
#             the start of the part.
#   + ends: The number of characters between the start of the source code and
#           the end of the part.
#   + class: A string describing what the part represents, of:
#       * "Comment": This is not a part of the parsed source code.
#       * "Literal": A primitive literal, such as "false" or "3.4".
#       * "Operator": A reference to a native operator, such as "+" or "not".
#       * "Parenthesis": A symbol representing a parenthesis.
#       * "Identifier": A user-created identifier, such as a declaration.
#       * "Unparsed": It is not known what this represents.
# Returns an array of objects reflecting the input, sorted by order of
# appearrance and any gaps filled with a class of "Comment", containing:
# - class: A string describing what the part represents, of:
#   + "Comment": This is not a part of the parsed source code.
#   + "Literal": A primitive literal, such as "false" or "3.4".
#   + "Operator": A reference to a native operator, such as "+" or "not".
#   + "Parenthesis": A symbol representing a parenthesis.
#   + "Identifier": A user-created identifier, such as a declaration.
#   + "Unparsed": It is not known what this represents.
# - code: The section of the source code covered.
module.exports = editorGenerateSyntaxHighlighting = (code, tokens) ->
    ended = 0
    output = []
    for run in (tokens.slice().sort (a, b) -> a.starts - b.starts)
        if run.starts > ended
            output.push
                starts: ended
                ends: run.starts - 1
                class: "Comment"
        output.push
            starts: run.starts
            ends: run.ends
            class: run.class
        ended = run.ends + 1
    if ended isnt code.length
        output.push
            starts: ended
            ends: code.length - 1
            class: "Comment"
    for run in output
        class: run.class
        code: code[run.starts..run.ends]