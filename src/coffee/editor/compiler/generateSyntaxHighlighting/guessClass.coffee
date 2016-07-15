# Given the a string containing the text in a token, returns a string containing
# the best guess at what it might represent syntactically.
# - true/false/./number: Literal
# - An operator keyword or symbol (+/add/etc.): Function
# - An opering or closing parenthesis: ((/)/etc.): Parenthesis
# - Otherwise: Unparsed
module.exports = editorCompilerGenerateSyntaxHighlightingGuessClass = (token) -> switch
    when token is "true" then "Literal"
    when token is "false" then "Literal"
    when token is "." then "Literal"
    when /^\d+$/.test token then "Literal"
    else
        for key, values of expressionParseOperatorTokens
            if token in values then return "Function"
        for opener, closer of tokenizeParentheses
            if token is opener then return "Parenthesis"
            if token is closer then return "Parenthesis"
        "Unparsed"
    
expressionParseOperatorTokens = require "./../../../expression/parse/operatorTokens"
tokenizeParentheses = require "./../../../tokenize/parentheses"