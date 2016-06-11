describe "expression", -> describe "parse", -> describe "binary", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseBinary = rewire "./binary"
        it "expressionParse", -> (expect expressionParseBinary.__get__ "expressionParse").toBe require "./../parse"
        it "expressionParseOperatorTokens", -> (expect expressionParseBinary.__get__ "expressionParseOperatorTokens").toBe require "./operatorTokens"
    describe "on calling", ->
        expressionParseBinary = rewire "./binary"
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
                    expressionParseBinary.__set__ "expressionParse", (input) ->
                        if config.expectTokens
                            for option in config.expectTokens
                                if option.tokens[0].token isnt input[0].token then continue
                                (expect input).toEqual option.tokens
                                return option.output
                            fail "unexpected call to expressionParse"
                        else
                            fail "unexpected call to expressionParse"
                    expressionParseBinary.__set__ "expressionParseOperatorTokens", expressionParseOperatorTokensCopy
                    result = expressionParseBinary inputCopy, operatorsCopy
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
                output: null
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
                output: null
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
                output: null
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
        describe "three tokens", ->
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
                ]
                output: null
            run
                description: "when the second is an operator match on this level"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                            token: "irrelevantC"
                            starts: 122
                            ends: 146
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96
            run
                description: "when the third is an operator match on this level"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "when the first is an operator match on another level"
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
                ]
                output: null
            run
                description: "when the second is an operator match on another level"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolDB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "when the third is an operator match on another level"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolDB"
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "when the first two are the same operator match on this level"
                tokens: [
                        token: "testOperatorSymbolBB"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "when the first two are operator matches on this level"
                tokens: [
                        token: "testOperatorSymbolCC"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "when the first is an operator match on this level and the second is an operator match on another level"
                tokens: [
                        token: "testOperatorSymbolCC"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolAD"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "when the second is an operator match on this level and the third is an operator match on the same level"
                tokens: [
                        token: "testOperatorSymbolAD"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolCC"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "when the second is an operator match on this level and the third is an operator match on this level"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolCC"
                        starts: 122
                        ends: 146
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                            token: "testOperatorSymbolCC"
                            starts: 122
                            ends: 146
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96
            run
                description: "when the second is an operator match on this level and the third is an operator match on noahter level"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolAB"
                        starts: 122
                        ends: 146
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                            token: "testOperatorSymbolAB"
                            starts: 122
                            ends: 146
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96
            run
                description: "when the second is an operator match on another level and the third is an operator match on this level"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolDB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolCC"
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "when the second is an operator match on another level and the third is an operator match on noahter level"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolDB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolAB"
                        starts: 122
                        ends: 146
                ]
                output: null
        describe "numerous tokens", ->
            run
                description: "when more tokens are left of an operator than to the right"
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
                        token: "testOperatorSymbolBB"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
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
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                            token: "irrelevantE"
                            starts: 191
                            ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 166
                    ends: 180
            run
                description: "when more tokens are right of an operator than to the left"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
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
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "irrelevantC"
                                starts: 122
                                ends: 146
                            ,
                                token: "irrelevantD"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96
            run
                description: "when the same symbol appears multiple times"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 122
                        ends: 146
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                                token: "irrelevantA"
                                starts: 35
                                ends: 74
                            ,
                                token: "irrelevantB"
                                starts: 87
                                ends: 96
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "testOperatorSymbolBB"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 122
                    ends: 146
            run
                description: "when the different symbols for the same operator appear in definition order"
                tokens: [
                        token: "irrelevantA"
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
                        token: "testOperatorSymbolBB"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                                token: "irrelevantA"
                                starts: 35
                                ends: 74
                            ,
                                token: "irrelevantB"
                                starts: 87
                                ends: 96
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "testOperatorSymbolBB"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 122
                    ends: 146
            run
                description: "when the different symbols for the same operator appear out of definition order"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 122
                        ends: 146
                    ,
                        token: "testOperatorSymbolBA"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                                token: "irrelevantA"
                                starts: 35
                                ends: 74
                            ,
                                token: "irrelevantB"
                                starts: 87
                                ends: 96
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "testOperatorSymbolBA"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 122
                    ends: 146
            run
                description: "when different operators appear in definition order"
                tokens: [
                        token: "irrelevantA"
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
                        token: "testOperatorSymbolCB"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                                token: "irrelevantA"
                                starts: 35
                                ends: 74
                            ,
                                token: "irrelevantB"
                                starts: 87
                                ends: 96
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "testOperatorSymbolCB"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 122
                    ends: 146
            run
                description: "when different operators appear out of definition order"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolCB"
                        starts: 122
                        ends: 146
                    ,
                        token: "testOperatorSymbolBA"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                                token: "irrelevantA"
                                starts: 35
                                ends: 74
                            ,
                                token: "irrelevantB"
                                starts: 87
                                ends: 96
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "testOperatorSymbolBA"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorC"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 122
                    ends: 146
            run
                description: "when an operator from another level is at the start of the left tokens"
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
                        token: "testOperatorSymbolBA"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
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
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                            token: "irrelevantE"
                            starts: 191
                            ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 166
                    ends: 180
            run
                description: "when an operator from the same level is at the start of the left tokens"
                tokens: [
                        token: "testOperatorSymbolCB"
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
                        token: "testOperatorSymbolBA"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                                token: "testOperatorSymbolCB"
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
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                            token: "irrelevantE"
                            starts: 191
                            ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 166
                    ends: 180
            run
                description: "when an operator from another level is in the middle of the left tokens"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolDB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                    ,
                        token: "testOperatorSymbolBA"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                                token: "irrelevantA"
                                starts: 35
                                ends: 74
                            ,
                                token: "testOperatorSymbolDB"
                                starts: 87
                                ends: 96
                            ,
                                token: "irrelevantC"
                                starts: 122
                                ends: 146
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                            token: "irrelevantE"
                            starts: 191
                            ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 166
                    ends: 180
            run
                description: "when an operator from the same level is in the middle of the left tokens"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolCB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                    ,
                        token: "testOperatorSymbolBA"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "irrelevantC"
                                starts: 122
                                ends: 146
                            ,
                                token: "testOperatorSymbolBA"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorC"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96
            run
                description: "when an operator from another level is at the end of the left tokens"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolDB"
                        starts: 122
                        ends: 146
                    ,
                        token: "testOperatorSymbolBA"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                output: null
            run
                description: "when an operator from the same level is at the end of the left tokens"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "irrelevantB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolCB"
                        starts: 122
                        ends: 146
                    ,
                        token: "testOperatorSymbolBA"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                                token: "irrelevantA"
                                starts: 35
                                ends: 74
                            ,
                                token: "irrelevantB"
                                starts: 87
                                ends: 96
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "testOperatorSymbolBA"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorC"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 122
                    ends: 146
            run
                description: "when an operator from another level is at the start of the right tokens"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolDB"
                        starts: 122
                        ends: 146
                    ,
                        token: "irrelevantD"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "testOperatorSymbolDB"
                                starts: 122
                                ends: 146
                            ,
                                token: "irrelevantD"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96
            run
                description: "when an operator from the same level is at the start of the right tokens"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                    ,
                        token: "testOperatorSymbolCB"
                        starts: 122
                        ends: 146
                    ,
                        token: "irrelevantD"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "testOperatorSymbolCB"
                                starts: 122
                                ends: 146
                            ,
                                token: "irrelevantD"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96
            run
                description: "when an operator from another level is in the middle of the right tokens"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                    ,
                        token: "testOperatorSymbolDB"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "irrelevantC"
                                starts: 122
                                ends: 146
                            ,
                                token: "testOperatorSymbolDB"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96
            run
                description: "when an operator from the same level is in the middle of the right tokens"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
                        starts: 87
                        ends: 96
                    ,
                        token: "irrelevantC"
                        starts: 122
                        ends: 146
                    ,
                        token: "testOperatorSymbolCB"
                        starts: 166
                        ends: 180
                    ,
                        token: "irrelevantE"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "irrelevantC"
                                starts: 122
                                ends: 146
                            ,
                                token: "testOperatorSymbolCB"
                                starts: 166
                                ends: 180
                            ,
                                token: "irrelevantE"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96
            run
                description: "when an operator from another level is at the end of the right tokens"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
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
                    ,
                        token: "testOperatorSymbolDB"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "irrelevantC"
                                starts: 122
                                ends: 146
                            ,
                                token: "irrelevantD"
                                starts: 166
                                ends: 180
                            ,
                                token: "testOperatorSymbolDB"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96
            run
                description: "when an operator from the same level is at the end of the right tokens"
                tokens: [
                        token: "irrelevantA"
                        starts: 35
                        ends: 74
                    ,
                        token: "testOperatorSymbolBB"
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
                    ,
                        token: "testOperatorSymbolCB"
                        starts: 191
                        ends: 203
                ]
                expectTokens: [
                        tokens: [
                            token: "irrelevantA"
                            starts: 35
                            ends: 74
                        ]
                        output: "recursed left expression"
                    ,
                        tokens: [
                                token: "irrelevantC"
                                starts: 122
                                ends: 146
                            ,
                                token: "irrelevantD"
                                starts: 166
                                ends: 180
                            ,
                                token: "testOperatorSymbolCB"
                                starts: 191
                                ends: 203
                        ]
                        output: "recursed right expression"
                ]
                output: 
                    call: "testOperatorB"
                    with: ["recursed left expression", "recursed right expression"]
                    starts: 87
                    ends: 96