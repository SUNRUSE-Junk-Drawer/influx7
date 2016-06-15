# Given a string which may represent an identifier, returns true if it does, and
# false if it does not.
# Identifiers must be at least one character long, start with a-z and be
# followed by a-z and/or 0-9.
module.exports = isIdentifier = (str) -> switch
    when str is null or str is undefined then false
    when (tokenizeKeywords.indexOf str) isnt -1 then false
    when (tokenizeSymbols.indexOf str) isnt -1 then false
    else /^[a-z][a-z0-9]*$/.test str
    
tokenizeKeywords = require "./tokenize/keywords"
tokenizeSymbols = require "./tokenize/symbols"