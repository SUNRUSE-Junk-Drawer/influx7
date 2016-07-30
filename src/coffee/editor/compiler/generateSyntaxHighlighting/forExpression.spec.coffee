describe "editor", -> describe "compiler", -> describe "generateSyntaxHighlighting", -> describe "forExpression", ->
    rewire = require "rewire"
    describe "imports", ->
        editorCompilerGenerateSyntaxHighlightingForExpression = rewire "./forExpression"
        it "itself", -> (expect editorCompilerGenerateSyntaxHighlightingForExpression.__get__ "recurse").toBe editorCompilerGenerateSyntaxHighlightingForExpression
    describe "on calling", ->
        editorCompilerGenerateSyntaxHighlightingForExpression = rewire "./forExpression"
    
        run = (config) -> describe config.description, ->
            result = inputCopy = outputCopy = recursesToCopy = undefined
            beforeEach ->           
                editorCompilerGenerateSyntaxHighlightingForExpression.__set__ "recurse", (input) ->
                    if recursesToCopy
                        toReturn = recursesToCopy[input]
                        if toReturn is undefined
                            fail "unexpected recursion to #{input}"
                        else
                            toReturn
                    else
                        fail "unexpected recursion"
                inputCopy = JSON.parse JSON.stringify config.input
                outputCopy = JSON.parse JSON.stringify config.output
                recursesToCopy = JSON.parse JSON.stringify config.recursesTo or null
                result = editorCompilerGenerateSyntaxHighlightingForExpression inputCopy
            it "does not modify the input", -> (expect inputCopy).toEqual config.input
            it "returns the expected output", -> (expect result).toEqual config.output
            it "does not modify any recursed tokens", -> (expect recursesToCopy).toEqual config.recursesTo or null
            
        run
            description: "truthy primitive"
            input:
                primitive: "integer"
                value: 87
                starts: 320
                ends: 360
            output: [
                starts: 320
                ends: 360
                class: "Literal"
            ]
            
        run
            description: "falsy primitive"     
            input:
                primitive: "boolean"
                value: false
                starts: 320
                ends: 360
            output: [
                starts: 320
                ends: 360
                class: "Literal"
            ]
            
        run
            description: "function"
            input:
                call: "testFunctionB"
                with: [
                    "testArgumentA"
                    "testArgumentB"
                    "testArgumentC"
                ]
                starts: 320
                ends: 360
            recursesTo:
                testArgumentA: [
                    "test recursed argument a a"
                    "test recursed argument a b"
                ]
                testArgumentB: [
                    "test recursed argument b"
                ]
                testArgumentC: [
                    "test recursed argument c a"
                    "test recursed argument c b"
                    "test recursed argument c c"
                    "test recursed argument c d"
                ]
            output: [
                    starts: 320
                    ends: 360
                    class: "Function"
                ,
                    "test recursed argument a a"
                    "test recursed argument a b"
                    "test recursed argument b"
                    "test recursed argument c a"
                    "test recursed argument c b"
                    "test recursed argument c c"
                    "test recursed argument c d"
            ]
            
        run
            description: "return"
            input:
                return: "testReturnExpression"
                starts: 320
                ends: 360
            recursesTo:
                testReturnExpression: [
                    "test recursed return expression a"
                    "test recursed return expression b"
                    "test recursed return expression c"
                ]
            output: [
                    starts: 320
                    ends: 360
                    class: "Statement"
                ,
                    "test recursed return expression a"
                    "test recursed return expression b"
                    "test recursed return expression c"
            ]
            
        run
            description: "parentheses"
            input:
                parentheses: "testParenthesesExpression"
                starts: 320
                ends: 360
            recursesTo:
                testParenthesesExpression: [
                    "test recursed parentheses expression a"
                    "test recursed parentheses expression b"
                    "test recursed parentheses expression c"
                ]
            output: [
                    starts: 320
                    ends: 320
                    class: "Parenthesis"
                ,
                    "test recursed parentheses expression a"
                    "test recursed parentheses expression b"
                    "test recursed parentheses expression c"
                ,
                    starts: 360
                    ends: 360
                    class: "Parenthesis"
            ]
            
        run
            description: "reference"
            input:
                reference: "testReference"
                starts: 320
                ends: 360
            output: [
                starts: 320
                ends: 360
                class: "Identifier"
            ]