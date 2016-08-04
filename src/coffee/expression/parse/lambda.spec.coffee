describe "expression", -> describe "parse", -> describe "lambda", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseLambda = rewire "./lambda"
        it "isIdentifier", -> (expect expressionParseLambda.__get__ "isIdentifier").toBe require "./../../isIdentifier"
        it "expressionParse", -> (expect expressionParseLambda.__get__ "expressionParse").toBe require "./../parse"
    describe "on calling", ->
        expressionParseLambda = rewire "./lambda"
        run = (config) -> describe config.description, ->
            isIdentifier = inputCopy = undefined
            beforeEach ->
                isIdentifier = jasmine.createSpy "isIdentifier"
                expressionParseLambda.__set__ "isIdentifier", isIdentifier
                isIdentifier.and.callFake (identifier) ->
                    if not config.validatesNewIdentifiers
                        fail "unexpected call to isIdentifier"
                    else
                        mapping = config.validatesNewIdentifiers[identifier]
                        if mapping is undefined
                            fail "unexpected call to isIdentifier for #{identifier}"
                        else
                            mapping
                
                expressionParseLambda.__set__ "expressionParse", (tokens) ->
                    if config.recursesTo
                        (expect tokens).toEqual config.recursesTo
                        "test recursed expression"
                    else
                        fail "unexpected recursion"
                
                inputCopy = JSON.parse JSON.stringify config.input
            
            if config.throws
                it "throws the expected exception", -> (expect -> expressionParseLambda inputCopy).toThrow config.throws
            else
                it "returns the expected output", -> (expect expressionParseLambda inputCopy).toEqual config.output

            describe "then", ->
                beforeEach ->
                    try
                        expressionParseLambda inputCopy
                    catch e
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
                
        run
            description: "nothing"
            input: []
            output: null
            
        run
            description: "one irrelevant token"
            input: [
                token: "test token one"
                starts: 40
                ends: 60
            ]
            output: null
            
        run
            description: "multiple irrelevant tokens"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "test token two"
                    starts: 130
                    ends: 167
                ,
                    token: "test token three"
                    starts: 221
                    ends: 274
            ]
            output: null
            
        run
            description: "one lambda delimiter"
            input: [
                token: "->"
                starts: 40
                ends: 60
            ]
            throws:
                reason: "noParameters"
                starts: 40
                ends: 60
                
        run
            description: "one irrelevant token preceding a lambda delimiter"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "->"
                    starts: 130
                    ends: 167
            ]
            validatesNewIdentifiers:
                "test token one": true
            output: null
            throws:
                reason: "emptyExpression"
                starts: 130
                ends: 167
                
        run
            description: "one irrelevant token following a lambda delimiter"
            input: [
                    token: "->"
                    starts: 40
                    ends: 60
                ,
                    token: "test token one"
                    starts: 130
                    ends: 167
            ]
            output: null
            throws:
                reason: "noParameters"
                starts: 40
                ends: 60
                
        run
            description: "one lambda delimiter surrounded by irrelevant tokens"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "->"
                    starts: 130
                    ends: 167
                ,
                    token: "test token three"
                    starts: 221
                    ends: 274
            ]
            validatesNewIdentifiers:
                "test token one": true
            recursesTo: [
                token: "test token three"
                starts: 221
                ends: 274
            ]
            output:
                parameters: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ]
                body: "test recursed expression"
                starts: 130
                ends: 167
                
        run
            description: "one lambda delimiter preceded by multiple irrelevant tokens"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "test token two"
                    starts: 130
                    ends: 160
                ,
                    token: "test token three"
                    starts: 177
                    ends: 189
                ,
                    token: "->"
                    starts: 214
                    ends: 244
            ]
            isIdentifier:
                "test token one": true
                "test token two": true
                "test token three": true
            throws:
                reason: "emptyExpression"
                starts: 214
                ends: 244
                
        run
            description: "one lambda delimiter preceded by multiple irrelevant tokens and followed by an irrelevant token"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "test token two"
                    starts: 130
                    ends: 160
                ,
                    token: "test token three"
                    starts: 177
                    ends: 189
                ,
                    token: "->"
                    starts: 214
                    ends: 244
                ,
                    token: "test token five"
                    starts: 260
                    ends: 289
            ]
            validatesNewIdentifiers:
                "test token one": true
                "test token two": true
                "test token three": true
            recursesTo: [
                token: "test token five"
                starts: 260
                ends: 289
            ]
            output:
                parameters: [
                        token: "test token one"
                        starts: 40
                        ends: 60
                    ,
                        token: "test token two"
                        starts: 130
                        ends: 160
                    ,
                        token: "test token three"
                        starts: 177
                        ends: 189
                ]
                body: "test recursed expression"
                starts: 214
                ends: 244
                
        run
            description: "one lambda delimiter preceded by multiple irrelevant tokens and followed by multiple irrelevant tokens"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "test token two"
                    starts: 130
                    ends: 160
                ,
                    token: "test token three"
                    starts: 177
                    ends: 189
                ,
                    token: "->"
                    starts: 214
                    ends: 244
                ,
                    token: "test token five"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "test token seven"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            validatesNewIdentifiers:
                "test token one": true
                "test token two": true
                "test token three": true
            recursesTo: [
                    token: "test token five"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "test token seven"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            output:
                parameters: [
                        token: "test token one"
                        starts: 40
                        ends: 60
                    ,
                        token: "test token two"
                        starts: 130
                        ends: 160
                    ,
                        token: "test token three"
                        starts: 177
                        ends: 189
                ]
                body: "test recursed expression"
                starts: 214
                ends: 244
                
        run
            description: "one lambda delimiter preceded by multiple irrelevant tokens and followed by multiple irrelevant tokens including another delimiter"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "test token two"
                    starts: 130
                    ends: 160
                ,
                    token: "test token three"
                    starts: 177
                    ends: 189
                ,
                    token: "->"
                    starts: 214
                    ends: 244
                ,
                    token: "test token five"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "->"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            validatesNewIdentifiers:
                "test token one": true
                "test token two": true
                "test token three": true
            recursesTo: [
                    token: "test token five"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "->"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            output:
                parameters: [
                        token: "test token one"
                        starts: 40
                        ends: 60
                    ,
                        token: "test token two"
                        starts: 130
                        ends: 160
                    ,
                        token: "test token three"
                        starts: 177
                        ends: 189
                ]
                body: "test recursed expression"
                starts: 214
                ends: 244
                
        run
            description: "one lambda delimiter preceded by one irrelevant token and followed by multiple irrelevant tokens"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "->"
                    starts: 214
                    ends: 244
                ,
                    token: "test token five"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "test token seven"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            validatesNewIdentifiers:
                "test token one": true
            recursesTo: [
                    token: "test token five"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "test token seven"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            output:
                parameters: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ]
                body: "test recursed expression"
                starts: 214
                ends: 244
                
        run
            description: "one lambda delimiter preceded by one irrelevant token and followed by multiple irrelevant tokens including another delimiter"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "->"
                    starts: 214
                    ends: 244
                ,
                    token: "test token five"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "->"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            validatesNewIdentifiers:
                "test token one": true
            recursesTo: [
                    token: "test token five"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "->"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            output:
                parameters: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ]
                body: "test recursed expression"
                starts: 214
                ends: 244
                
        run
            description: "first and last parameters not unique"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "test token two"
                    starts: 130
                    ends: 160
                ,
                    token: "test token three"
                    starts: 177
                    ends: 189
                ,
                    token: "test token one"
                    starts: 214
                    ends: 244
                ,
                    token: "->"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "->"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            validatesNewIdentifiers:
                "test token one": true
                "test token two": true
                "test token three": true
            throws:
                reason: "duplicateParameters"
                starts: 214
                ends: 244
                
        run
            description: "first and middle parameters not unique"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "test token two"
                    starts: 130
                    ends: 160
                ,
                    token: "test token one"
                    starts: 177
                    ends: 189
                ,
                    token: "test token four"
                    starts: 214
                    ends: 244
                ,
                    token: "->"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "->"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            validatesNewIdentifiers:
                "test token one": true
                "test token two": true
                "test token four": true
            throws:
                reason: "duplicateParameters"
                starts: 177
                ends: 189
                
        run
            description: "middle parameters not unique"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "test token two"
                    starts: 130
                    ends: 160
                ,
                    token: "test token two"
                    starts: 177
                    ends: 189
                ,
                    token: "test token four"
                    starts: 214
                    ends: 244
                ,
                    token: "->"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "->"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            validatesNewIdentifiers:
                "test token one": true
                "test token two": true
                "test token four": true
            throws:
                reason: "duplicateParameters"
                starts: 177
                ends: 189
                
        run
            description: "middle and last parameters not unique"
            input: [
                    token: "test token one"
                    starts: 40
                    ends: 60
                ,
                    token: "test token two"
                    starts: 130
                    ends: 160
                ,
                    token: "test token three"
                    starts: 177
                    ends: 189
                ,
                    token: "test token two"
                    starts: 214
                    ends: 244
                ,
                    token: "->"
                    starts: 260
                    ends: 289
                ,
                    token: "test token six"
                    starts: 310
                    ends: 346
                ,
                    token: "->"
                    starts: 360
                    ends: 384
                ,
                    token: "test token eight"
                    starts: 394
                    ends: 412
            ]
            validatesNewIdentifiers:
                "test token one": true
                "test token two": true
                "test token three": true
            throws:
                reason: "duplicateParameters"
                starts: 214
                ends: 244
                
        xit "nonexistent identifiers", ->