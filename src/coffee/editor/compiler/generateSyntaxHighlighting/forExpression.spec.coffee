describe "editor", -> describe "compiler", -> describe "generateSyntaxHighlighting", -> describe "forExpression", ->
    rewire = require "rewire"
    describe "imports", ->
        editorCompilerGenerateSyntaxHighlightingForExpression = rewire "./forExpression"
        it "itself", -> (expect editorCompilerGenerateSyntaxHighlightingForExpression.__get__ "recurse").toBe editorCompilerGenerateSyntaxHighlightingForExpression
    describe "on calling", ->
        editorCompilerGenerateSyntaxHighlightingForExpression = rewire "./forExpression"
    
        run = (config) -> describe config.description, ->
            result = inputCopy = outputCopy = undefined
            beforeEach ->           
                editorCompilerGenerateSyntaxHighlightingForExpression.__set__ "recurse", (input) ->
                    if config.recursesTo is undefined
                        fail "unexpected recursion"
                    else
                        outputCopy = config.recursesTo[input]
                        if outputCopy is undefined
                            fail "unexpected recursion to #{input}"
                        else
                            outputCopy
                inputCopy = JSON.parse JSON.stringify config.input
                outputCopy = JSON.parse JSON.stringify config.output
                result = editorCompilerGenerateSyntaxHighlightingForExpression inputCopy
            it "does not modify the input", -> (expect inputCopy).toEqual config.input
            it "returns the expected output", -> (expect result).toEqual config.output
            
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