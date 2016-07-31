describe "expression", -> describe "parse", -> describe "statement", -> describe "functions", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseStatementFunctions = rewire "./functions"
        it "expressionParse", -> (expect expressionParseStatementFunctions.__get__ "expressionParse").toBe require "./../../parse"
        it "expressionParseStatementFindNext", -> (expect expressionParseStatementFunctions.__get__ "expressionParseStatementFindNext").toBe require "./findNext"
        it "isIdentifier", -> (expect expressionParseStatementFunctions.__get__ "isIdentifier").toBe require "./../../../isIdentifier"
    describe "on calling", ->
        expressionParseStatementFunctions = rewire "./functions"
    
        statementToken = 
            token: "test statement token"
            starts: 27
            ends: 65
    
        includes = (name, _then) -> describe name, ->
            _then (config) -> describe config.description, ->
                getsNextStatementCopy = parsesExpressionCopy = statementTokenCopy = inputCopy = undefined
                beforeEach ->
                    parsesExpressionCopy = JSON.parse JSON.stringify config.parsesExpression or null
                    expressionParseStatementFunctions.__set__ "expressionParse", (tokens) ->
                        if parsesExpressionCopy
                            (expect tokens).toEqual parsesExpressionCopy
                            "test parsed expression"
                        else
                            fail "unexpected call to expressionParse"
                            
                    statementTokenCopy = JSON.parse JSON.stringify statementToken
                    
                    inputCopy = JSON.parse JSON.stringify config.input
                    
                    expressionParseStatementFunctions.__set__ "isIdentifier", (str) -> switch str
                        when "test valid identifier" then true
                        when "test invalid identifier" then false
                        else fail "unexpected validation of identifier #{str}"
                        
                    if config.getsNextStatement
                        getsNextStatementCopy = JSON.parse JSON.stringify config.getsNextStatement
                        getsNextStatementCopy.statementFunction = config.getsNextStatement.statementFunction
                    else
                        config.getsNextStatement = undefined
                    expressionParseStatementFunctions.__set__ "expressionParseStatementFindNext", (tokens) ->
                        if config.getsNextStatementOf
                            (expect tokens).toEqual config.getsNextStatementOf
                            getsNextStatementCopy
                        else fail "unexpected call to expressionParseStatementFindNext"
                if config.throws
                    it "throws the expected object", -> (expect -> expressionParseStatementFunctions[name] statementTokenCopy, inputCopy).toThrow config.throws
                else
                    it "returns the expected object", -> (expect expressionParseStatementFunctions[name] statementTokenCopy, inputCopy).toEqual config.output
                describe "then", ->
                    beforeEach ->
                        try
                            expressionParseStatementFunctions[name] statementTokenCopy, inputCopy
                        catch ex
                    it "does not modify the parsed expression", -> (expect parsesExpressionCopy).toEqual config.parsesExpression or null
                    it "does not modify the statement token", -> (expect statementTokenCopy).toEqual statementToken
                    it "does not modify the input", -> (expect inputCopy).toEqual config.input
                    it "does not modify the returned next statement", -> (expect getsNextStatementCopy).toEqual config.getsNextStatement
            
        includes "return", (run) ->
            run
                description: "no tokens"
                input: []
                throws:
                    reason: "emptyExpression"
                    starts: 27
                    ends: 65
                
            run 
                description: "one token"
                input: ["test token a"]
                parsesExpression: ["test token a"]
                output: 
                    return: "test parsed expression"
                    starts: 27
                    ends: 65
                
            run
                description: "multiple tokens"
                input: ["test token a", "test token b", "test token c"]
                parsesExpression: ["test token a", "test token b", "test token c"]
                output:
                    return: "test parsed expression"
                    starts: 27
                    ends: 65

        includes "let", (run) ->
                
            run
                description: "no tokens"
                input: []
                throws: 
                    reason: "identifierExpected"
                    starts: 27
                    ends: 65

            run
                description: "one token which is an invalid identifier"
                input: [
                    token: "test invalid identifier"
                    starts: 134
                    ends: 156
                ]
                throws:
                    reason: "identifierInvalid"
                    starts: 134
                    ends: 156
                    
            run
                description: "one token which is a valid identifier"
                input: [
                    token: "test valid identifier"
                    starts: 134
                    ends: 156
                ]
                throws:
                    reason: "emptyExpression"
                    starts: 27
                    ends: 156
                    
            run
                description: "two tokens the first of which is an invalid identifier"
                input: [
                        token: "test invalid identifier"
                        starts: 134
                        ends: 156
                    ,
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                ]
                throws:
                    reason: "identifierInvalid"
                    starts: 134
                    ends: 156
                    
            run
                description: "two tokens the first of which is a valid identifier but no next statement exists"
                input: [
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    ,
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                ]
                getsNextStatementOf: [
                    token: "test irrelevant token a"
                    starts: 187
                    ends: 219
                ]
                getsNextStatement: null
                throws:
                    reason: "returnExpected"
                    starts: 187
                    ends: 219
                    
            run
                description: "two tokens the first of which is a valid identifier with a next statement but the expression is empty"
                input: [
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    ,
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                ]
                getsNextStatementOf: [
                    token: "test irrelevant token a"
                    starts: 187
                    ends: 219
                ]
                getsNextStatement:
                    before: []
                    statement:
                        token: "test statement token"
                        starts: 267
                        ends: 324
                    statementFunction: -> fail "unexpected call to statement function"
                    after: "test statement tokens"
                throws:
                    reason: "emptyExpression"
                    starts: 27
                    ends: 156
                    
            run
                description: "two tokens the first of which is a valid identifier with a next statement and a single-token expression"
                input: [
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    ,
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                ]
                getsNextStatementOf: [
                    token: "test irrelevant token a"
                    starts: 187
                    ends: 219
                ]
                getsNextStatement:
                    before: [
                        "test expression token a"
                    ]
                    statement:
                        token: "test statement token"
                        starts: 267
                        ends: 324
                    statementFunction: (token, tokens) -> 
                        (expect token).toEqual 
                            token: "test statement token"
                            starts: 267
                            ends: 324
                        (expect tokens).toEqual "test statement tokens"
                        "test parsed statement"
                    after: "test statement tokens"
                parsesExpression: ["test expression token a"]
                output:
                    let:
                        token: "test statement token"
                        starts: 27
                        ends: 65
                    declare:
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    as: "test parsed expression"
                    then: "test parsed statement"
                    
            run
                description: "two tokens the first of which is a valid identifier with a next statement and a multi-token expression"
                input: [
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    ,
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                ]
                getsNextStatementOf: [
                    token: "test irrelevant token a"
                    starts: 187
                    ends: 219
                ]
                getsNextStatement:
                    before: [
                        "test expression token a"
                        "test expression token b"
                        "test expression token c"
                        "test expression token d"
                    ]
                    statement:
                        token: "test statement token"
                        starts: 267
                        ends: 324
                    statementFunction: (token, tokens) -> 
                        (expect token).toEqual 
                            token: "test statement token"
                            starts: 267
                            ends: 324
                        (expect tokens).toEqual "test statement tokens"
                        "test parsed statement"
                    after: "test statement tokens"
                parsesExpression: [
                    "test expression token a"
                    "test expression token b"
                    "test expression token c"
                    "test expression token d"
                ]
                output:
                    let:
                        token: "test statement token"
                        starts: 27
                        ends: 65
                    declare:
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    as: "test parsed expression"
                    then: "test parsed statement"
                    
            run
                description: "many tokens the first of which is an invalid identifier"
                input: [
                        token: "test invalid identifier"
                        starts: 134
                        ends: 156
                    ,
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                    ,
                        token: "test irrelevant token b"
                        starts: 349
                        ends: 598
                    ,
                        token: "test irrelevant token c"
                        starts: 948
                        ends: 1204
                ]
                throws:
                    reason: "identifierInvalid"
                    starts: 134
                    ends: 156
                    
            run
                description: "many tokens the first of which is a valid identifier but no next statement exists"
                input: [
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    ,
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                    ,
                        token: "test irrelevant token b"
                        starts: 349
                        ends: 598
                    ,
                        token: "test irrelevant token c"
                        starts: 948
                        ends: 1204
                ]
                getsNextStatementOf: [
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                    ,
                        token: "test irrelevant token b"
                        starts: 349
                        ends: 598
                    ,
                        token: "test irrelevant token c"
                        starts: 948
                        ends: 1204
                ]
                getsNextStatement: null
                throws:
                    reason: "returnExpected"
                    starts: 187
                    ends: 1204
                    
            run
                description: "many tokens the first of which is a valid identifier with a next statement but the expression is empty"
                input: [
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    ,
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                    ,
                        token: "test irrelevant token b"
                        starts: 349
                        ends: 598
                    ,
                        token: "test irrelevant token c"
                        starts: 948
                        ends: 1204
                ]
                getsNextStatementOf: [
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                    ,
                        token: "test irrelevant token b"
                        starts: 349
                        ends: 598
                    ,
                        token: "test irrelevant token c"
                        starts: 948
                        ends: 1204
                ]
                getsNextStatement:
                    before: []
                    statement:
                        token: "test statement token"
                        starts: 267
                        ends: 324
                    statementFunction: -> fail "unexpected call to statement function"
                    after: "test statement tokens"
                throws:
                    reason: "emptyExpression"
                    starts: 27
                    ends: 156
                    
            run
                description: "many tokens the first of which is a valid identifier with a next statement and a single-token expression"
                input: [
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    ,
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                    ,
                        token: "test irrelevant token b"
                        starts: 349
                        ends: 598
                    ,
                        token: "test irrelevant token c"
                        starts: 948
                        ends: 1204
                ]
                getsNextStatementOf: [
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                    ,
                        token: "test irrelevant token b"
                        starts: 349
                        ends: 598
                    ,
                        token: "test irrelevant token c"
                        starts: 948
                        ends: 1204
                ]
                getsNextStatement:
                    before: [
                        "test expression token a"
                    ]
                    statement:
                        token: "test statement token"
                        starts: 267
                        ends: 324
                    statementFunction: (token, tokens) -> 
                        (expect token).toEqual 
                            token: "test statement token"
                            starts: 267
                            ends: 324
                        (expect tokens).toEqual "test statement tokens"
                        "test parsed statement"
                    after: "test statement tokens"
                parsesExpression: ["test expression token a"]
                output:
                    let:
                        token: "test statement token"
                        starts: 27
                        ends: 65
                    declare:
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    as: "test parsed expression"
                    then: "test parsed statement"
                    
            run
                description: "many tokens the first of which is a valid identifier with a next statement and a multi-token expression"
                input: [
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    ,
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                    ,
                        token: "test irrelevant token b"
                        starts: 349
                        ends: 598
                    ,
                        token: "test irrelevant token c"
                        starts: 948
                        ends: 1204
                ]
                getsNextStatementOf: [
                        token: "test irrelevant token a"
                        starts: 187
                        ends: 219
                    ,
                        token: "test irrelevant token b"
                        starts: 349
                        ends: 598
                    ,
                        token: "test irrelevant token c"
                        starts: 948
                        ends: 1204
                ]
                getsNextStatement:
                    before: [
                        "test expression token a"
                        "test expression token b"
                        "test expression token c"
                        "test expression token d"
                    ]
                    statement:
                        token: "test statement token"
                        starts: 267
                        ends: 324
                    statementFunction: (token, tokens) -> 
                        (expect token).toEqual 
                            token: "test statement token"
                            starts: 267
                            ends: 324
                        (expect tokens).toEqual "test statement tokens"
                        "test parsed statement"
                    after: "test statement tokens"
                parsesExpression: [
                    "test expression token a"
                    "test expression token b"
                    "test expression token c"
                    "test expression token d"
                ]
                output:
                    let:
                        token: "test statement token"
                        starts: 27
                        ends: 65
                    declare:
                        token: "test valid identifier"
                        starts: 134
                        ends: 156
                    as: "test parsed expression"
                    then: "test parsed statement"