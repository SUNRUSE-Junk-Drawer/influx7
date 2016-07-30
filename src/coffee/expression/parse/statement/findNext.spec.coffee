describe "expression", -> describe "parse", -> describe "statement", -> describe "findNext", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseStatementFindNext = rewire "./findNext"
        it "expressionParseStatementFunctions", -> (expect expressionParseStatementFindNext.__get__ "expressionParseStatementFunctions").toBe require "./functions"
    describe "on calling", ->
        expressionParseStatementFindNext = rewire "./findNext"
    
        expressionParseStatementFunctions = 
            testStatementA: -> fail "unexpected call to testStatementA"
            testStatementB: -> fail "unexpected call to testStatementB"
            testStatementC: -> fail "unexpected call to testStatementC"
            testStatementD: -> fail "unexpected call to testStatementD"
    
        run = (config) -> describe config.description, ->
            inputCopy = expressionParseStatementFunctionsCopy = undefined
            beforeEach ->
                expressionParseStatementFunctionsCopy = {}
                for key, value of expressionParseStatementFunctions
                    expressionParseStatementFunctionsCopy[key] = value
                expressionParseStatementFindNext.__set__ "expressionParseStatementFunctions", expressionParseStatementFunctionsCopy
                inputCopy = JSON.parse JSON.stringify config.input
            if config.throws
                it "throws the expected object", -> (expect -> expressionParseStatementFindNext inputCopy).toThrow config.throws
            else
                it "returns the expected object", -> (expect expressionParseStatementFindNext inputCopy).toEqual config.output
            describe "then", ->
                beforeEach ->
                    try
                        expressionParseStatementFindNext inputCopy
                    catch ex
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
                it "does not modify expressionParseStatementFunctions", ->
                    (expect expressionParseStatementFunctionsCopy).toEqual expressionParseStatementFunctions
            
        run
            description: "nothing"
            input: []
            output: null
            
        run
            description: "non-statement only"
            input: [
                token: "test non-statement a"
                starts: 25
                ends: 37
            ]
            output: null
            
        run
            description: "statement only"
            input: [
                token: "testStatementB"
                starts: 25
                ends: 37
            ]
            output: 
                before: []
                statement:
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: []
            
        run
            description: "non-statement then statement"
            input: [
                    token: "test non-statement a"
                    starts: 25
                    ends: 37
                ,
                    token: "testStatementB"
                    starts: 64
                    ends: 78
            ]
            output: 
                before: [
                    token: "test non-statement a"
                    starts: 25
                    ends: 37
                ]
                statement:
                    token: "testStatementB"
                    starts: 64
                    ends: 78
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: []
            
        run
            description: "statement then non-statement"
            input: [
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement a"
                    starts: 64
                    ends: 78
            ]
            output: 
                before: []
                statement:
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: [
                    token: "test non-statement a"
                    starts: 64
                    ends: 78
                ]
            
        run
            description: "non-statement then non-statement"
            input: [
                    token: "test non-statement a"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement b"
                    starts: 64
                    ends: 78
            ]
            output: null
            
        run
            description: "statement then same statement"
            input: [
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                ,
                    token: "testStatementB"
                    starts: 64
                    ends: 78
            ]
            output: 
                before: []
                statement:
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: [
                    token: "testStatementB"
                    starts: 64
                    ends: 78
                ]
            
        run
            description: "statement then different statement"
            input: [
                    token: "testStatementC"
                    starts: 25
                    ends: 37
                ,
                    token: "testStatementB"
                    starts: 64
                    ends: 78
            ]
            output: 
                before: []
                statement:
                    token: "testStatementC"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementC
                after: [
                    token: "testStatementB"
                    starts: 64
                    ends: 78
                ]
            
        run
            description: "multiple non-statements then statement"
            input: [
                    token: "test non-statement a"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement b"
                    starts: 64
                    ends: 78
                ,
                    token: "testStatementB"
                    starts: 89
                    ends: 103
            ]
            output: 
                before: [
                        token: "test non-statement a"
                        starts: 25
                        ends: 37
                    ,
                        token: "test non-statement b"
                        starts: 64
                        ends: 78
                ]
                statement:
                    token: "testStatementB"
                    starts: 89
                    ends: 103
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: []

        run
            description: "statement then multiple non-statements"
            input: [
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement a"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement b"
                    starts: 89
                    ends: 103
            ]
            output: 
                before: []
                statement:
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: [
                        token: "test non-statement a"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement b"
                        starts: 89
                        ends: 103
                ]
            
        run
            description: "multiple non-statements then statement then different statement"
            input: [
                    token: "test non-statement a"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement b"
                    starts: 64
                    ends: 78
                ,
                    token: "testStatementB"
                    starts: 89
                    ends: 103
                ,
                    token: "testStatementC"
                    starts: 143
                    ends: 156
            ]
            output: 
                before: [
                        token: "test non-statement a"
                        starts: 25
                        ends: 37
                    ,
                        token: "test non-statement b"
                        starts: 64
                        ends: 78
                ]
                statement:
                    token: "testStatementB"
                    starts: 89
                    ends: 103
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: [
                    token: "testStatementC"
                    starts: 143
                    ends: 156
                ]

        run
            description: "statement then different statement then multiple non-statements"
            input: [
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                ,
                    token: "testStatementC"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement a"
                    starts: 89
                    ends: 103
                ,
                    token: "test non-statement b"
                    starts: 143
                    ends: 156
            ]
            output: 
                before: []
                statement:
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: [
                        token: "testStatementC"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement a"
                        starts: 89
                        ends: 103
                    ,
                        token: "test non-statement b"
                        starts: 143
                        ends: 156
                ]            
            
        run
            description: "multiple non-statements then statement then same statement"
            input: [
                    token: "test non-statement a"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement b"
                    starts: 64
                    ends: 78
                ,
                    token: "testStatementB"
                    starts: 89
                    ends: 103
                ,
                    token: "testStatementB"
                    starts: 143
                    ends: 156
            ]
            output: 
                before: [
                        token: "test non-statement a"
                        starts: 25
                        ends: 37
                    ,
                        token: "test non-statement b"
                        starts: 64
                        ends: 78
                ]
                statement:
                    token: "testStatementB"
                    starts: 89
                    ends: 103
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: [
                    token: "testStatementB"
                    starts: 143
                    ends: 156
                ]

        run
            description: "statement then same statement then multiple non-statements"
            input: [
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                ,
                    token: "testStatementB"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement a"
                    starts: 89
                    ends: 103
                ,
                    token: "test non-statement b"
                    starts: 143
                    ends: 156
            ]
            output: 
                before: []
                statement:
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: [
                        token: "testStatementB"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement a"
                        starts: 89
                        ends: 103
                    ,
                        token: "test non-statement b"
                        starts: 143
                        ends: 156
                ]   
            
        run
            description: "statement then multiple non-statements then same statement"
            input: [
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement a"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement b"
                    starts: 89
                    ends: 103
                ,
                    token: "testStatementB"
                    starts: 143
                    ends: 156
            ]
            output: 
                before: []
                statement:
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: [
                        token: "test non-statement a"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement b"
                        starts: 89
                        ends: 103
                    ,
                        token: "testStatementB"
                        starts: 143
                        ends: 156
                ]   
            
        run
            description: "statement then multiple non-statements then different statement"
            input: [
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement a"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement b"
                    starts: 89
                    ends: 103
                ,
                    token: "testStatementC"
                    starts: 143
                    ends: 156
            ]
            output: 
                before: []
                statement:
                    token: "testStatementB"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementB
                after: [
                        token: "test non-statement a"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement b"
                        starts: 89
                        ends: 103
                    ,
                        token: "testStatementC"
                        starts: 143
                        ends: 156
                ]  
            
        run
            description: "multiple non-statements then statement then multiple non-statements then different statement"
            input: [
                    token: "test non-statement a"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement b"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement c"
                    starts: 89
                    ends: 103
                ,
                    token: "testStatementC"
                    starts: 143
                    ends: 156
                ,
                    token: "test non-statement d"
                    starts: 184
                    ends: 206
                ,
                    token: "test non-statement e"
                    starts: 212
                    ends: 235
                ,
                    token: "testStatementB"
                    starts: 259
                    ends: 274
            ]
            output: 
                before: [
                        token: "test non-statement a"
                        starts: 25
                        ends: 37
                    ,
                        token: "test non-statement b"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement c"
                        starts: 89
                        ends: 103
                ]
                statement:
                    token: "testStatementC"
                    starts: 143
                    ends: 156
                statementFunction: expressionParseStatementFunctions.testStatementC
                after: [
                        token: "test non-statement d"
                        starts: 184
                        ends: 206
                    ,
                        token: "test non-statement e"
                        starts: 212
                        ends: 235
                    ,
                        token: "testStatementB"
                        starts: 259
                        ends: 274
                ]              

        run
            description: "statement then multiple non-statements then different statement then multiple non-statements"
            input: [
                    token: "testStatementC"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement a"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement b"
                    starts: 89
                    ends: 103
                ,
                    token: "testStatementB"
                    starts: 143
                    ends: 156
                ,
                    token: "test non-statement c"
                    starts: 184
                    ends: 206
                ,
                    token: "test non-statement d"
                    starts: 212
                    ends: 235
                ,
                    token: "test non-statement e"
                    starts: 259
                    ends: 274
            ]
            output: 
                before: []
                statement:
                    token: "testStatementC"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementC
                after: [
                        token: "test non-statement a"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement b"
                        starts: 89
                        ends: 103
                    ,
                        token: "testStatementB"
                        starts: 143
                        ends: 156
                    ,
                        token: "test non-statement c"
                        starts: 184
                        ends: 206
                    ,
                        token: "test non-statement d"
                        starts: 212
                        ends: 235
                    ,
                        token: "test non-statement e"
                        starts: 259
                        ends: 274
                ]   
            
        run
            description: "multiple non-statements then statement then multiple non-statements then same statement"
            input: [
                    token: "test non-statement a"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement b"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement c"
                    starts: 89
                    ends: 103
                ,
                    token: "testStatementC"
                    starts: 143
                    ends: 156
                ,
                    token: "test non-statement d"
                    starts: 184
                    ends: 206
                ,
                    token: "test non-statement e"
                    starts: 212
                    ends: 235
                ,
                    token: "testStatementC"
                    starts: 259
                    ends: 274
            ]
            output: 
                before: [
                        token: "test non-statement a"
                        starts: 25
                        ends: 37
                    ,
                        token: "test non-statement b"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement c"
                        starts: 89
                        ends: 103
                ]
                statement:
                    token: "testStatementC"
                    starts: 143
                    ends: 156
                statementFunction: expressionParseStatementFunctions.testStatementC
                after: [
                        token: "test non-statement d"
                        starts: 184
                        ends: 206
                    ,
                        token: "test non-statement e"
                        starts: 212
                        ends: 235
                    ,
                        token: "testStatementC"
                        starts: 259
                        ends: 274
                ]   

        run
            description: "statement then multiple non-statements then same statement then multiple non-statements"
            input: [
                    token: "testStatementC"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement a"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement b"
                    starts: 89
                    ends: 103
                ,
                    token: "testStatementC"
                    starts: 143
                    ends: 156
                ,
                    token: "test non-statement c"
                    starts: 184
                    ends: 206
                ,
                    token: "test non-statement d"
                    starts: 212
                    ends: 235
                ,
                    token: "test non-statement e"
                    starts: 259
                    ends: 274
            ]
            output: 
                before: []
                statement:
                    token: "testStatementC"
                    starts: 25
                    ends: 37
                statementFunction: expressionParseStatementFunctions.testStatementC
                after: [
                        token: "test non-statement a"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement b"
                        starts: 89
                        ends: 103
                    ,
                        token: "testStatementC"
                        starts: 143
                        ends: 156
                    ,
                        token: "test non-statement c"
                        starts: 184
                        ends: 206
                    ,
                        token: "test non-statement d"
                        starts: 212
                        ends: 235
                    ,
                        token: "test non-statement e"
                        starts: 259
                        ends: 274
                ]   
            
        run
            description: "multiple non-statements then statement then multiple non-statements then same statement then multiple non-statements"
            input: [
                    token: "test non-statement a"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement b"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement c"
                    starts: 89
                    ends: 103
                ,
                    token: "testStatementC"
                    starts: 143
                    ends: 156
                ,
                    token: "test non-statement d"
                    starts: 184
                    ends: 206
                ,
                    token: "test non-statement e"
                    starts: 212
                    ends: 235
                ,
                    token: "testStatementC"
                    starts: 259
                    ends: 274
                ,
                    token: "test non-statement f"
                    starts: 298
                    ends: 304
                ,
                    token: "test non-statement g"
                    starts: 335
                    ends: 374
                ,
                    token: "test non-statement h"
                    starts: 437
                    ends: 475
            ]
            output: 
                before: [
                        token: "test non-statement a"
                        starts: 25
                        ends: 37
                    ,
                        token: "test non-statement b"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement c"
                        starts: 89
                        ends: 103
                ]
                statement:
                    token: "testStatementC"
                    starts: 143
                    ends: 156
                statementFunction: expressionParseStatementFunctions.testStatementC
                after: [
                        token: "test non-statement d"
                        starts: 184
                        ends: 206
                    ,
                        token: "test non-statement e"
                        starts: 212
                        ends: 235
                    ,
                        token: "testStatementC"
                        starts: 259
                        ends: 274
                    ,
                        token: "test non-statement f"
                        starts: 298
                        ends: 304
                    ,
                        token: "test non-statement g"
                        starts: 335
                        ends: 374
                    ,
                        token: "test non-statement h"
                        starts: 437
                        ends: 475
                ]

        run
            description: "multiple non-statements then statement then multiple non-statements then different statement then multiple non-statements"
            input: [
                    token: "test non-statement a"
                    starts: 25
                    ends: 37
                ,
                    token: "test non-statement b"
                    starts: 64
                    ends: 78
                ,
                    token: "test non-statement c"
                    starts: 89
                    ends: 103
                ,
                    token: "testStatementC"
                    starts: 143
                    ends: 156
                ,
                    token: "test non-statement d"
                    starts: 184
                    ends: 206
                ,
                    token: "test non-statement e"
                    starts: 212
                    ends: 235
                ,
                    token: "testStatementB"
                    starts: 259
                    ends: 274
                ,
                    token: "test non-statement f"
                    starts: 298
                    ends: 304
                ,
                    token: "test non-statement g"
                    starts: 335
                    ends: 374
                ,
                    token: "test non-statement h"
                    starts: 437
                    ends: 475
            ]
            output: 
                before: [
                        token: "test non-statement a"
                        starts: 25
                        ends: 37
                    ,
                        token: "test non-statement b"
                        starts: 64
                        ends: 78
                    ,
                        token: "test non-statement c"
                        starts: 89
                        ends: 103
                ]
                statement:
                    token: "testStatementC"
                    starts: 143
                    ends: 156
                statementFunction: expressionParseStatementFunctions.testStatementC
                after: [
                        token: "test non-statement d"
                        starts: 184
                        ends: 206
                    ,
                        token: "test non-statement e"
                        starts: 212
                        ends: 235
                    ,
                        token: "testStatementB"
                        starts: 259
                        ends: 274
                    ,
                        token: "test non-statement f"
                        starts: 298
                        ends: 304
                    ,
                        token: "test non-statement g"
                        starts: 335
                        ends: 374
                    ,
                        token: "test non-statement h"
                        starts: 437
                        ends: 475
                ]