describe "editor", -> describe "compiler", -> describe "generateSyntaxHighlighting", -> describe "forToken", ->
    rewire = require "rewire"
    describe "imports", ->
        editorCompilerGenerateSyntaxHighlightingForToken = rewire "./forToken"
        it "itself", -> (expect editorCompilerGenerateSyntaxHighlightingForToken.__get__ "recurse").toBe editorCompilerGenerateSyntaxHighlightingForToken
        it "editorCompilerGenerateSyntaxHighlightingGuessClass", -> (expect editorCompilerGenerateSyntaxHighlightingForToken.__get__ "editorCompilerGenerateSyntaxHighlightingGuessClass").toBe require "./guessClass"
        it "tokenizeParentheses", -> (expect editorCompilerGenerateSyntaxHighlightingForToken.__get__ "tokenizeParentheses").toBe require "./../../../tokenize/parentheses"
    describe "on calling", ->
        editorCompilerGenerateSyntaxHighlightingForToken = rewire "./forToken"
    
        tokenizeParentheses = 
            testLeftParenthesisA: "testRightParenthesisA"
            testLeftParenthesisB: "testRightParenthesisB"
            testLeftParenthesisC: "testRightParenthesisC"
            
        run = (config) -> describe config.description, ->
            inputCopy = result = tokenizeParenthesesCopy = undefined
            beforeEach ->
                editorCompilerGenerateSyntaxHighlightingForToken.__set__ "editorCompilerGenerateSyntaxHighlightingGuessClass", (input) ->
                    if config.guessesClass is undefined
                        fail "unexpected call to editorCompilerGenerateSyntaxHighlightingGuessClass"
                    else
                        output = config.guessesClass[input]
                        if output is undefined 
                            fail "unexpected call to editorCompilerGenerateSyntaxHighlightingGuessClass for #{input}"
                        else
                            output
                editorCompilerGenerateSyntaxHighlightingForToken.__set__ "recurse", (input) ->
                    if config.recursesTo is undefined
                        fail "unexpected recursion"
                    else
                        output = config.recursesTo[input]
                        if output is undefined
                            fail "unexpected recursion to #{input}"
                        else
                            output
                tokenizeParenthesesCopy = JSON.parse JSON.stringify tokenizeParentheses
                editorCompilerGenerateSyntaxHighlightingForToken.__set__ "tokenizeParentheses", tokenizeParenthesesCopy
                inputCopy = JSON.parse JSON.stringify config.input
                result = editorCompilerGenerateSyntaxHighlightingForToken inputCopy
            it "does not modify tokenizeParentheses", -> (expect tokenizeParenthesesCopy).toEqual tokenizeParentheses
            it "does not modify the input", -> (expect inputCopy).toEqual config.input
            it "returns the expected result", -> (expect result).toEqual config.output
            
        run
            description: "single token without end"
            guessesClass:
                "test token": "test guessed class"
            input:
                starts: 250
                token: "test token"
            output: [
                starts: 250
                ends: 259
                class: "test guessed class"
            ]
            
        run
            description: "single token which is an opening parenthesis without end"
            guessesClass:
                testLeftParenthesisB: "Parenthesis"
            input:
                starts: 250
                token: "testLeftParenthesisB"
            output: [
                starts: 250
                ends: 269
                class: "Parenthesis"
            ]
            
        run
            description: "single token which is a closing parenthesis without end"
            guessesClass:
                testRightParenthesisB: "Parenthesis"
            input:
                starts: 250
                token: "testRightParenthesisB"
            output: [
                starts: 250
                ends: 270
                class: "Parenthesis"
            ]
            
        run
            description: "single token with end"
            guessesClass:
                "test token": "test guessed class"
            input:
                starts: 250
                ends: 259
                token: "test token"
            output: [
                starts: 250
                ends: 259
                class: "test guessed class"
            ]
            
        run
            description: "parentheses"
            recursesTo:
                testChildA: "test recursed child a"
                testChildB: "test recursed child b"
                testChildC: "test recursed child c"
            guessesClass:
                testLeftParenthesisB: "Parenthesis"
                testRightParenthesisB: "Parenthesis"
            input:
                starts: 250
                ends: 314
                token: "testLeftParenthesisB"
                children: ["testChildA", "testChildB", "testChildC"]
            output: [
                    starts: 250
                    ends: 269
                    class: "Parenthesis"
                ,
                    "test recursed child a"
                    "test recursed child b"
                    "test recursed child c"
                ,
                    starts: 294
                    ends: 314
                    class: "Parenthesis"
            ]