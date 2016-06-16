# Exports an object, where keys are statement keywords and values functions to
# call to parse them, taking:
# - The array of token objects to parse; this should include the token which
#   declared the statement, so a range of tokens are available for error 
#   handling.
# - The statement object output by the preceding statement, if any, else, null.
# - The declarations object 
# And returning the final result of the program; if there is another statement
# following, you should recurse to statementParse.
module.exports = statementParseStatements =
    "function": (tokens, input, declarations) -> throw "TODO"