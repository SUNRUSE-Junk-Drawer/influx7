describe "tokenize", -> describe "parentheses", ->
    tokenizeParentheses = require "./parentheses"
    
    it "includes (/)", -> (expect tokenizeParentheses["("]).toEqual ")"