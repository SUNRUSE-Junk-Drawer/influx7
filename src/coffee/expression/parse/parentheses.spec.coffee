describe "expression", -> describe "parse", -> describe "parentheses", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseParentheses = rewire "./parentheses"
        it "expressionParse", -> (expect expressionParseParentheses.__get__ "expressionParse").toBe require "./../parse"
    describe "on calling", ->
        expressionParseParentheses = rewire "./parentheses"
        run = (config) ->
            describe config.description, ->
                inputCopy = undefined
                beforeEach ->
                    inputCopy = JSON.parse JSON.stringify config.input
                    expressionParseParentheses.__set__ "expressionParse", (given) ->
                        if config.expectRecursion
                            (expect given).toEqual config.expectRecursion
                            if config.invalid then null else "test recursed"
                        else
                            fail "unexpected recursion"
            
                if config.throws
                    it "throws the expected exception", -> (expect -> expressionParseParentheses inputCopy).toThrow config.throws
                else
                    it "returns the expected output", -> (expect expressionParseParentheses inputCopy).toEqual config.output
                    
                beforeEach ->
                    try
                        expressionParseParentheses inputCopy
                    catch
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
        run
            description: "empty parentheses"
            input: [
                token: "("
                children: []
                starts: 23
                ends: 245
            ]
            throws:
                reason: "emptyExpression"
                starts: 23
                ends: 245
        run
            description: "empty parentheses of wrong type"
            input: [
                token: "["
                children: []
                starts: 23
                ends: 245
            ]
            output: null
        run
            description: "non-empty parentheses of wrong type"
            input: [
                token: "["
                children: [
                        token: "irrelevant"
                        starts: 30
                        ends: 70
                    ,
                        token: "alsoirrelevant"
                        starts: 90
                        ends: 140
                ]
                starts: 23
                ends: 245
            ]
            output: null
        run
            description: "empty parentheses followed by other tokens"
            input: [
                    token: "("
                    children: []
                    starts: 23
                    ends: 245
                ,
                    token: "alsoirrelevant"
                    starts: 260
                    ends: 280
            ]
            output: null
        run
            description: "empty parentheses preceded by other tokens"
            input: [
                    token: "alsoirrelevant"
                    starts: 2
                    ends: 15
                ,
                    token: "("
                    children: []
                    starts: 23
                    ends: 245
            ]
            output: null
        run
            description: "empty parentheses followed by other parentheses"
            input: [
                    token: "("
                    children: []
                    starts: 23
                    ends: 245
                ,
                    token: "("
                    children: [
                        "irrelevant"
                        "alsoirrelevant"
                    ]
                    starts: 263
                    ends: 289
            ]
            output: null
        run
            description: "empty parentheses preceded by other parentheses"
            input: [
                    token: "("
                    children: [
                        "irrelevant"
                        "alsoirrelevant"
                    ]
                    starts: 23
                    ends: 245
                ,
                    token: "("
                    children: []
                    starts: 23
                    ends: 245
            ]
            output: null
        run
            description: "non-empty parentheses followed by other tokens"
            input: [
                    token: "("
                    children: [
                        "irrelevant"
                        "alsoirrelevant"
                    ]
                    starts: 23
                    ends: 245
                ,
                    "youguessedit"
            ]
            output: null
        run
            description: "non-empty parentheses preceded by other tokens"
            input: [
                    "youguessedit"
                ,
                    token: "("
                    children: [
                        "irrelevant"
                        "alsoirrelevant"
                    ]
                    starts: 23
                    ends: 245
            ]
            output: null
        run
            description: "non-empty parentheses followed by other parentheses"
            input: [
                    token: "("
                    children: [
                        "irrelevant"
                        "alsoirrelevant"
                    ]
                    starts: 23
                    ends: 245
                ,
                    token: "("
                    children: [
                        "youguessedit"
                    ]
                    starts: 23
                    ends: 245
            ]
            output: null
        run
            description: "parentheses containing a single token forming a valid expression"
            input: [
                token: "("
                children: [
                    token: "irrelevant"
                    starts: 30
                    ends: 70
                ]
                starts: 23
                ends: 245
            ]
            expectRecursion: [
                token: "irrelevant"
                starts: 30
                ends: 70
            ]
            output: 
                parentheses: "test recursed"
                starts: 23
                ends: 245
        run
            description: "parentheses containing multiple tokens forming a valid expression"
            input: [
                token: "("
                children: [
                        token: "irrelevant"
                        starts: 30
                        ends: 70
                    ,
                        token: "alsoirrelevant"
                        starts: 90
                        ends: 140
                    ,
                        token: "youguessedit"
                        starts: 160
                        ends: 190
                ]
                starts: 23
                ends: 245
            ]
            expectRecursion: [
                    token: "irrelevant"
                    starts: 30
                    ends: 70
                ,
                    token: "alsoirrelevant"
                    starts: 90
                    ends: 140
                ,
                    token: "youguessedit"
                    starts: 160
                    ends: 190
            ]
            output: 
                parentheses: "test recursed"
                starts: 23
                ends: 245            
        run
            description: "parentheses containing a single token forming an invalid expression"
            input: [
                token: "("
                children: [
                    token: "irrelevant"
                    starts: 30
                    ends: 70
                ]
                starts: 23
                ends: 245
            ]
            expectRecursion: [
                token: "irrelevant"
                starts: 30
                ends: 70
            ]
            throws:
                reason: "invalidExpression"
                starts: 23
                ends: 245
            invalid: true
        run
            description: "parentheses containing multiple tokens forming an invalid expression"
            input: [
                token: "("
                children: [
                        token: "irrelevant"
                        starts: 30
                        ends: 70
                    ,
                        token: "alsoirrelevant"
                        starts: 90
                        ends: 140
                    ,
                        token: "youguessedit"
                        starts: 160
                        ends: 190
                ]
                starts: 23
                ends: 245
            ]
            expectRecursion: [
                    token: "irrelevant"
                    starts: 30
                    ends: 70
                ,
                    token: "alsoirrelevant"
                    starts: 90
                    ends: 140
                ,
                    token: "youguessedit"
                    starts: 160
                    ends: 190
            ]
            throws:
                reason: "invalidExpression"
                starts: 23
                ends: 245
            invalid: true