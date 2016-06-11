# Given a string representing source code, runs it through
# tokenize/splitByWhitespace, tokenize/splitToken and tokenize/parenthesize and
# returns the result.
module.exports = tokenize = (input) -> 
    items = []
    (items = items.concat tokenizeSplitToken token) for token in tokenizeSplitByWhitespace input
    tokenizeParenthesize items

tokenizeSplitByWhitespace = require "./tokenize/splitByWhitespace"
tokenizeSplitToken = require "./tokenize/splitToken"
tokenizeParenthesize = require "./tokenize/parenthesize"