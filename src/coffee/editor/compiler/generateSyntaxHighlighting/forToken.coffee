# Given either a parenthesized or unparenthesized token object, returns a flat
# array of objects describing all token objects within it, containing:
# - starts: The number of characters between the start of the code and this
#           token.
# - ends: The number of characters between the start of the code and the end of 
#         this token.
# - class: A string describing the token; see ./guessClass.
module.exports = editorCompilerGenerateSyntaxHighlightingForToken = (token) ->
    if token.children
        output = [
            starts: token.starts
            ends: token.starts + token.token.length - 1
            class: "Parenthesis"
        ]
        for child in token.children
            output = output.concat recurse child
        output.push
            starts: 1 + token.ends - tokenizeParentheses[token.token].length
            ends: token.ends
            class: "Parenthesis"
        output
    else
        [
            starts: token.starts
            ends: token.starts + token.token.length - 1
            class: editorCompilerGenerateSyntaxHighlightingGuessClass token.token
        ]
        
recurse = module.exports
tokenizeParentheses = require "./../../../tokenize/parentheses"
editorCompilerGenerateSyntaxHighlightingGuessClass = require "./guessClass"