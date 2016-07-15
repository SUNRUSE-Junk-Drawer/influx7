describe "editor", -> describe "compiler", -> describe "generateSyntaxHighlighting", -> describe "guessClass", ->
    rewire = require "rewire"
    describe "imports", ->
        editorCompilerGenerateSyntaxHighlightingGuessClass = rewire "./guessClass"
        it "tokenizeParentheses", -> (expect editorCompilerGenerateSyntaxHighlightingGuessClass.__get__ "tokenizeParentheses").toBe require "./../../../tokenize/parentheses"
        it "expressionParseOperatorTokens", -> (expect editorCompilerGenerateSyntaxHighlightingGuessClass.__get__ "expressionParseOperatorTokens").toBe require "./../../../expression/parse/operatorTokens"
    describe "on calling", ->
        editorCompilerGenerateSyntaxHighlightingGuessClass = rewire "./guessClass"
        
        tokenizeParentheses = 
            testLeftParenthesisA: "testRightParenthesisA"
            testLeftParenthesisB: "testRightParenthesisB"
            testLeftParenthesisC: "testRightParenthesisC"
            
        expressionParseOperatorTokens = 
            testOperatorA: ["testOperatorATokenA", "testOperatorATokenB"]
            testOperatorB: ["testOperatorBTokenA", "testOperatorBTokenB", "testOperatorBTokenC", "testOperatorBTokenD"]
            testOperatorC: ["testOperatorCTokenA", "testOperatorCTokenB", "testOperatorCTokenC"]
        
        maps = (config) -> describe config.input, -> 
            result = tokenizeParenthesesCopy = expressionParseOperatorTokensCopy = undefined
            beforeEach ->
                tokenizeParenthesesCopy = JSON.parse JSON.stringify tokenizeParentheses
                editorCompilerGenerateSyntaxHighlightingGuessClass.__set__ "tokenizeParentheses", tokenizeParenthesesCopy
                expressionParseOperatorTokensCopy = JSON.parse JSON.stringify expressionParseOperatorTokens
                editorCompilerGenerateSyntaxHighlightingGuessClass.__set__ "expressionParseOperatorTokens", expressionParseOperatorTokensCopy
                result = editorCompilerGenerateSyntaxHighlightingGuessClass config.input
            it "does not modify tokenizeParentheses", -> (expect tokenizeParenthesesCopy).toEqual tokenizeParentheses
            it "does not modify expressionParseOperatorTokens", -> (expect expressionParseOperatorTokensCopy).toEqual expressionParseOperatorTokens
            it "returns the expected output", -> (expect result).toEqual config.output
            
        maps
            input: "true"
            output: "Literal"
            
        maps
            input: "false"
            output: "Literal"
            
        maps
            input: "."
            output: "Literal"
            
        maps
            input: "0"
            output: "Literal"
            
        maps
            input: "00"
            output: "Literal"
            
        maps
            input: "3"
            output: "Literal"
            
        maps
            input: "75"
            output: "Literal"
            
        maps
            input: "testLeftParenthesisB"
            output: "Parenthesis"
            
        maps
            input: "testRightParenthesisB"
            output: "Parenthesis"
            
        maps
            input: "testOperatorBTokenC"
            output: "Function"
            
        maps
            input: "testUnidentifiableToken"
            output: "Unparsed"