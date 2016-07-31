describe "editor", -> describe "compiler", -> describe "generateSyntaxHighlighting", -> describe "guessClass", ->
    rewire = require "rewire"
    describe "imports", ->
        editorCompilerGenerateSyntaxHighlightingGuessClass = rewire "./guessClass"
        it "tokenizeParentheses", -> (expect editorCompilerGenerateSyntaxHighlightingGuessClass.__get__ "tokenizeParentheses").toBe require "./../../../tokenize/parentheses"
        it "expressionParseOperatorTokens", -> (expect editorCompilerGenerateSyntaxHighlightingGuessClass.__get__ "expressionParseOperatorTokens").toBe require "./../../../expression/parse/operatorTokens"
        it "expressionParseStatementFunctions", -> (expect editorCompilerGenerateSyntaxHighlightingGuessClass.__get__ "expressionParseStatementFunctions").toBe require "./../../../expression/parse/statement/functions"
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
            
        expressionParseStatementFunctions = 
            testStatementA: -> fail "unexpected call to testStatementA"
            testStatementB: -> fail "unexpected call to testStatementB"
            testStatementC: -> fail "unexpected call to testStatementC"
        
        maps = (config) -> describe config.input, -> 
            result = expressionParseStatementFunctionsCopy = tokenizeParenthesesCopy = expressionParseOperatorTokensCopy = undefined
            beforeEach ->
                tokenizeParenthesesCopy = JSON.parse JSON.stringify tokenizeParentheses
                editorCompilerGenerateSyntaxHighlightingGuessClass.__set__ "tokenizeParentheses", tokenizeParenthesesCopy
                expressionParseOperatorTokensCopy = JSON.parse JSON.stringify expressionParseOperatorTokens
                editorCompilerGenerateSyntaxHighlightingGuessClass.__set__ "expressionParseOperatorTokens", expressionParseOperatorTokensCopy
                expressionParseStatementFunctionsCopy = {}
                for key, value of expressionParseStatementFunctions
                    expressionParseStatementFunctionsCopy[key] = value
                editorCompilerGenerateSyntaxHighlightingGuessClass.__set__ "expressionParseStatementFunctions", expressionParseStatementFunctionsCopy
                result = editorCompilerGenerateSyntaxHighlightingGuessClass config.input
            it "does not modify tokenizeParentheses", -> (expect tokenizeParenthesesCopy).toEqual tokenizeParentheses
            it "does not modify expressionParseOperatorTokens", -> (expect expressionParseOperatorTokensCopy).toEqual expressionParseOperatorTokens
            it "does not modify expressionParseStatementFunctions", -> (expect expressionParseStatementFunctionsCopy).toEqual expressionParseStatementFunctions
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
            input: "testStatementB"
            output: "Statement"
            
        maps
            input: "testLeftParenthesisB"
            output: "Parenthesis"
            
        maps
            input: "testRightParenthesisB"
            output: "Parenthesis"
            
        maps
            input: "testOperatorBTokenC"
            output: "Operator"
            
        maps
            input: "testUnidentifiableToken"
            output: "Unparsed"