describe "expression", -> describe "parse", -> describe "unary", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseUnary = rewire "./unary"
        it "expressionParse", -> (expect expressionParseUnary.__get__ "expressionParse").toBe require "./../parse"
        it "expressionParseOperatorTokens", -> (expect expressionParseUnary.__get__ "expressionParseOperatorTokens").toBe require "./operatorTokens"
    describe "on calling", ->
        expressionParseUnary = rewire "./unary"
        operators = ["testOperatorB", "testOperatorC"]
        expressionParseOperatorTokens = 
            testOperatorA: ["testOperatorSymbolAA", "testOperatorSymbolAB", "testOperatorSymbolAC", "testOperatorSymbolAD"]
            testOperatorB: ["testOperatorSymbolBA", "testOperatorSymbolBB"]
            testOperatorC: ["testOperatorSymbolCA", "testOperatorSymbolCB", "testOperatorSymbolCC"]
            testOperatorD: ["testOperatorSymbolDA", "testOperatorSymbolDB"]
        run = (config) ->
            describe config.description, ->
                result = inputCopy = operatorsCopy = expressionParseOperatorTokensCopy = undefined
                beforeEach ->                    
                    inputCopy = JSON.parse JSON.stringify config.tokens
                    operatorsCopy = JSON.parse JSON.stringify operators
                    expressionParseOperatorTokensCopy = JSON.parse JSON.stringify expressionParseOperatorTokens
                    expressionParseUnary.__set__ "expressionParse", (input) ->
                        if config.expectTokens
                            (expect input).toEqual config.expectTokens
                            "recursed expression"
                        else
                            fail "unexpected call to expressionParse"
                    expressionParseUnary.__set__ "expressionParseOperatorTokens", expressionParseOperatorTokensCopy
                    result = expressionParseUnary inputCopy, operatorsCopy
                it "returns the expected result", -> (expect result).toEqual config.output    
                it "does not modify the input tokens", -> (expect inputCopy).toEqual config.tokens
                it "does not modify the input operators", -> (expect operatorsCopy).toEqual operators
                it "does not modify expressionParseOperatorTokens", -> (expect expressionParseOperatorTokensCopy).toEqual expressionParseOperatorTokens
        describe "one token", ->
            run
                description: "which is not a symbol or keyword match"
                tokens: [
                    token: "irrelevant"
                    starts: 35
                    ends: 74
                ]
                output: null
            run
                description: "which is an operator match on this level"
                tokens: [
                    token: "testOperatorSymbolBB"
                    starts: 35
                    ends: 74
                ]
                output: null
            run
                description: "which is an operator match on another level"
                tokens: [
                    token: "testOperatorSymbolAC"
                    starts: 35
                    ends: 74
                ]
                output: null
        describe "two tokens", ->
            run
                description: "which are not operator matches"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                ]
                output: null
            run
                description: "an operator match on this level followed by another token"
                tokens: [
                        token: "testOperatorSymbolBB"
                        starts: 35
                        ends: 74

                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                ]
                expectTokens: [
                    token: "irrelevantB"
                    starts: 87
                    ends: 96
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed expression"]
                    starts: 35
                    ends: 74
            run
                description: "an operator match on this level followed by another token which is also an operator match"
                tokens: [
                        token: "testOperatorSymbolBB"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolCA"
                        starts: 87
                        ends: 96
                ]
                expectTokens: [
                    token: "testOperatorSymbolCA"
                    starts: 87
                    ends: 96
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed expression"]
                    starts: 35
                    ends: 74
            run
                description: "an operator match on this level followed by the same token"
                tokens: [
                        token: "testOperatorSymbolBB"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                ]
                expectTokens: [
                    token: "testOperatorSymbolBB"
                    starts: 87
                    ends: 96
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed expression"]
                    starts: 35
                    ends: 74
            run
                description: "one token which is an operator match on another level followed by another token"
                tokens: [
                        token: "testOperatorSymbolAC"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                ]
                output: null
            run
                description: "an irrelevant token followed by an operator match on this level"
                tokens: [
                        token: "irrelevantB"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                ]
                output: null
            run
                description: "an irrelevant token followed by one token which is an operator match on another level"
                tokens: [
                        token: "irrelevantB"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolAC"
                        starts: 87
                        ends: 96
                ]
                output: null
        describe "more than two tokens", ->
            run
                description: "which are not operator matches"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                    ,
                        token: "irrelevantD"
                        starts: 166
                        ends: 180
                ]
                output: null
            run
                description: "when the first is an operator match on this level"
                tokens: [
                        token: "testOperatorSymbolBB"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                    ,
                        token: "irrelevantD"
                        starts: 166
                        ends: 180
                ]
                expectTokens: [
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                    ,
                        token: "irrelevantD"
                        starts: 166
                        ends: 180
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed expression"]
                    starts: 35
                    ends: 74
            run
                description: "when multiple are an operator match on this level"
                tokens: [
                        token: "testOperatorSymbolCC"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolBA"
                        starts: 122
                        ends: 146
                    ,
                        token: "irrelevantD"
                        starts: 166
                        ends: 180
                ]
                expectTokens: [
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolBA"
                        starts: 122
                        ends: 146
                    ,
                        token: "irrelevantD"
                        starts: 166
                        ends: 180
                ]
                output: 
                    call: "testOperatorC"
                    with: ["recursed expression"]
                    starts: 35
                    ends: 74
            run
                description: "when the first is an operator match not on this level"
                tokens: [
                        token: "testOperatorSymbolDB"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                    ,
                        token: "irrelevantD"
                        starts: 166
                        ends: 180
                ]
                output: null