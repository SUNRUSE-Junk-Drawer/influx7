# Given: 
# - The token object which should be a previously unused identifier.
# - The declarations object.
# Throws an object should it be invalid, containing:
# - reason: A string describing the problem, of:
#   + identifierInvalid: The token did not represent a valid identifier (see 
#                        ./isIdentifier).
#   + identifierNotUnique: The token was a valid identifier, but has already
#                          been defined here and as such could be ambiguous.
# - starts: The number of characters between the start of the code and the start
#           of the token.
# - ends: The number of characters between the start of the code and the end
#           of the token.
module.exports = validateNewIdentifier = (token, declarations) -> 
    if not isIdentifier token.token then throw unused = 
        reason: "identifierInvalid"
        starts: token.starts
        ends: token.ends
    if declarations[token.token] then throw unused = 
        reason: "identifierNotUnique"
        starts: token.starts
        ends: token.ends

isIdentifier = require "./isIdentifier"