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
                    class: "Operator"
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
            
        run
            description: "let"
            input:
                let: 
                    token: "let"
                    starts: 35
                    ends: 47
                declare:
                    token: "test identifier"
                    starts: 80
                    ends: 104
                as: "test declared expression"
                then: "test subsequent expression"
            recursesTo:
                "test declared expression": [
                    "test recursed declared expression a"
                    "test recursed declared expression b"
                    "test recursed declared expression c"
                    "test recursed declared expression d"
                ]
                "test subsequent expression": [
                    "test recursed subsequent expression a"
                    "test recursed subsequent expression b"
                    "test recursed subsequent expression c"
                ]
            output: [
                    starts: 35
                    ends: 47
                    class: "Statement"
                ,
                    starts: 80
                    ends: 104
                    class: "Identifier"
                ,
                    "test recursed declared expression a"
                    "test recursed declared expression b"
                    "test recursed declared expression c"
                    "test recursed declared expression d"
                    "test recursed subsequent expression a"
                    "test recursed subsequent expression b"
                    "test recursed subsequent expression c"
            ]
            
        run
            description: "lambda"
            input:
                parameters: [
                        token: "test parameter token a"
                        starts: 14
                        ends: 27
                    ,
                        token: "test parameter token b"
                        starts: 45
                        ends: 67
                    ,
                        token: "test parameter token c"
                        starts: 132
                        ends: 156
                ]
                body: "test body expression"
                starts: 194
                ends: 244
            recursesTo:
                "test body expression": [
                    "test recursed body expression a"
                    "test recursed body expression b"
                    "test recursed body expression c"
                    "test recursed body expression d"
                ]
            output: [
                    starts: 14
                    ends: 27
                    class: "Identifier"
                ,
                    starts: 45
                    ends: 67
                    class: "Identifier"
                ,
                    starts: 132
                    ends: 156
                    class: "Identifier"
                ,
                    starts: 194
                    ends: 244
                    class: "Statement"
                ,
                    "test recursed body expression a"
                    "test recursed body expression b"
                    "test recursed body expression c"
                    "test recursed body expression d"
            ]
            
        run
            description: "lambda call"
            input:
                callLambda: "test lambda expression"
                with: [
                    "test argument expression a"
                    "test argument expression b"
                    "test argument expression c"
                ]
                starts: 14
                ends: 132
            recursesTo:
                "test lambda expression": [
                    "test recursed lambda expression a"
                    "test recursed lambda expression b"
                    "test recursed lambda expression c"
                    "test recursed lambda expression d"
                    "test recursed lambda expression e"
                ]
                "test argument expression a": [
                    "test recursed argument expression a a"
                    "test recursed argument expression a b"
                    "test recursed argument expression a c"
                ]
                "test argument expression b": [
                    "test recursed argument expression b a"
                    "test recursed argument expression b b"
                ]
                "test argument expression c": [
                    "test recursed argument expression c a"
                    "test recursed argument expression c b"
                    "test recursed argument expression c c"
                ]
            output: [
                    "test recursed lambda expression a"
                    "test recursed lambda expression b"
                    "test recursed lambda expression c"
                    "test recursed lambda expression d"
                    "test recursed lambda expression e"
                ,
                    class: "Parenthesis"
                    starts: 14
                    ends: 14
                ,
                    "test recursed argument expression a a"
                    "test recursed argument expression a b"
                    "test recursed argument expression a c"
                    "test recursed argument expression b a"
                    "test recursed argument expression b b"
                    "test recursed argument expression c a"
                    "test recursed argument expression c b"
                    "test recursed argument expression c c"
                ,
                    class: "Parenthesis"
                    starts: 132
                    ends: 132
            ]