describe "expression", -> describe "parse", -> describe "statement", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseStatement = rewire "./statement"
        it "expressionParseStatementFindNext", -> (expect expressionParseStatement.__get__ "expressionParseStatementFindNext").toBe require "./statement/findNext"
    describe "on calling", ->
        expressionParseStatement = rewire "./statement"
        run = (config) -> describe config.description, ->
            findsNextCopy = undefined
            beforeEach -> 
                findsNextCopy = JSON.parse JSON.stringify config.findsNext
                if findsNextCopy then findsNextCopy.statementFunction = config.findsNext.statementFunction
                expressionParseStatement.__set__ "expressionParseStatementFindNext", (tokens) ->
                    (expect tokens).toEqual "test input"
                    findsNextCopy
            if config.throws
                it "throws the expected object", -> (expect -> expressionParseStatement "test input").toThrow config.throws
            else
                it "return the expected object", -> (expect expressionParseStatement "test input").toEqual config.output
            describe "then", ->
                it "does not modify the result of findNext", -> (expect findsNextCopy).toEqual config.findsNext
        
        run
            description: "no statement"
            findsNext: null
            output: null
            
        run
            description: "statement only"
            findsNext:
                before: []
                statement:
                    token: "testStatementB"
                    starts: 37
                    ends: 48
                statementFunction: (token, tokens) ->
                    (expect token).toEqual 
                        token: "testStatementB"
                        starts: 37
                        ends: 48
                    (expect tokens).toEqual []
                    "test result"
                after: []
            output: "test result"
            
        run
            description: "statement with one preceding token"
            findsNext:
                before: [
                    token: "test preceding token a"
                    starts: 18
                    ends: 27
                ]
                statement:
                    token: "testStatementB"
                    starts: 37
                    ends: 48
                statementFunction: -> fail "unexpected call to statementFunction"
                after: []
            output: null
            
        run
            description: "statement with multiple preceding tokens"
            findsNext:
                before: [
                        token: "test preceding token a"
                        starts: 18
                        ends: 27
                    ,
                        token: "test preceding token b"
                        starts: 34
                        ends: 56
                    ,
                        token: "test preceding token c"
                        starts: 74
                        ends: 93
                ]
                statement:
                    token: "testStatementB"
                    starts: 37
                    ends: 48
                statementFunction: -> fail "unexpected call to statementFunction"
                after: []
            output: null
            
        run
            description: "statement only and one following token"
            findsNext:
                before: []
                statement:
                    token: "testStatementB"
                    starts: 37
                    ends: 48
                statementFunction: (token, tokens) ->
                    (expect token).toEqual 
                        token: "testStatementB"
                        starts: 37
                        ends: 48
                    (expect tokens).toEqual [
                        token: "test preceding token a"
                        starts: 18
                        ends: 27
                    ]
                    "test result"
                after: [
                    token: "test preceding token a"
                    starts: 18
                    ends: 27
                ]
            output: "test result"
            
        run
            description: "statement with one preceding token and one following token"
            findsNext:
                before: [
                    token: "test preceding token a"
                    starts: 18
                    ends: 27
                ]
                statement:
                    token: "testStatementB"
                    starts: 37
                    ends: 48
                statementFunction: -> fail "unexpected call to statementFunction"
                after: [
                    token: "test preceding token b"
                    starts: 34
                    ends: 56
                ]
            output: null
            
        run
            description: "statement with multiple preceding tokens and one following token"
            findsNext:
                before: [
                        token: "test preceding token a"
                        starts: 18
                        ends: 27
                    ,
                        token: "test preceding token b"
                        starts: 34
                        ends: 56
                    ,
                        token: "test preceding token c"
                        starts: 74
                        ends: 93
                ]
                statement:
                    token: "testStatementB"
                    starts: 37
                    ends: 48
                statementFunction: -> fail "unexpected call to statementFunction"
                after: [
                    token: "test preceding token d"
                    starts: 124
                    ends: 136
                ]
            output: null
            
        run
            description: "statement only and multiple following tokens"
            findsNext:
                before: []
                statement:
                    token: "testStatementB"
                    starts: 37
                    ends: 48
                statementFunction: (token, tokens) ->
                    (expect token).toEqual 
                        token: "testStatementB"
                        starts: 37
                        ends: 48
                    (expect tokens).toEqual [
                            token: "test preceding token a"
                            starts: 18
                            ends: 27
                        ,
                            token: "test preceding token b"
                            starts: 34
                            ends: 56
                        ,
                            token: "test preceding token c"
                            starts: 74
                            ends: 93
                    ]
                    "test result"
                after: [
                        token: "test preceding token a"
                        starts: 18
                        ends: 27
                    ,
                        token: "test preceding token b"
                        starts: 34
                        ends: 56
                    ,
                        token: "test preceding token c"
                        starts: 74
                        ends: 93
                ]
            output: "test result"
            
        run
            description: "statement with one preceding token and multiple following tokens"
            findsNext:
                before: [
                    token: "test preceding token a"
                    starts: 18
                    ends: 27
                ]
                statement:
                    token: "testStatementB"
                    starts: 37
                    ends: 48
                statementFunction: -> fail "unexpected call to statementFunction"
                after: [
                        token: "test preceding token b"
                        starts: 34
                        ends: 56
                    ,
                        token: "test preceding token c"
                        starts: 74
                        ends: 93
                ]
            output: null
            
        run
            description: "statement with multiple preceding tokens and multiple following tokens"
            findsNext:
                before: [
                        token: "test preceding token a"
                        starts: 18
                        ends: 27
                    ,
                        token: "test preceding token b"
                        starts: 34
                        ends: 56
                    ,
                        token: "test preceding token c"
                        starts: 74
                        ends: 93
                ]
                statement:
                    token: "testStatementB"
                    starts: 37
                    ends: 48
                statementFunction: -> fail "unexpected call to statementFunction"
                after: [
                        token: "test preceding token d"
                        starts: 124
                        ends: 136
                    ,
                        token: "test preceding token e"
                        starts: 146
                        ends: 164
                ]
            output: null