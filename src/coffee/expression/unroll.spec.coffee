describe "expression", -> describe "unroll", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionUnroll = rewire "./unroll"
        it "expressionUnrollFunctions", -> (expect expressionUnroll.__get__ "expressionUnrollFunctions").toBe require "./unroll/functions"
    describe "on calling", ->
        expressionUnroll = rewire "./unroll"
        run = (config) -> describe config.description, ->
            result = expressionCopy = expressionUnrollFunctionsCopy = undefined
            beforeEach ->
                expressionUnrollFunctionsCopy = {}
                for key, value of config.expressionUnrollFunctions
                    expressionUnrollFunctionsCopy[key] = value
                expressionUnroll.__set__ "expressionUnrollFunctions", expressionUnrollFunctionsCopy
                expressionCopy = JSON.parse JSON.stringify config.expression
                result = expressionUnroll expressionCopy, config.item
            it "does not modify the input", -> (expect expressionCopy).toEqual config.expression
            it "returns the expected result", -> (expect result).toEqual config.output
            it "does not modify expressionUnrollFunctions", -> (expect expressionUnrollFunctionsCopy).toEqual config.expressionUnrollFunctions

        run
            description: "first of primitive"
            expression:
                primitive: "test primitive"
                value: "test value"
                starts: "test starts"
                ends: "test ends"
            item: 0
            output:
                primitive: "test primitive"
                value: "test value"
                starts: "test starts"
                ends: "test ends"
            expressionUnrollFunctions:
                testFunctionA: -> fail "unexpected call to unroll function a"
                testFunctionB: -> fail "unexpected call to unroll function b"
                testFunctionC: -> fail "unexpected call to unroll function c"
                
        run
            description: "first of function"
            expression:
                call: "testFunctionB"
                with: "test arguments"
                starts: "test starts"
                ends: "test ends"
            item: 0
            output: "test unrolled function"
            expressionUnrollFunctions:
                testFunctionA: -> fail "unexpected call to unroll function a"
                testFunctionB: (expression, item) ->
                    (expect expression).toEqual 
                        call: "testFunctionB"
                        with: "test arguments"
                        starts: "test starts"
                        ends: "test ends"
                    (expect item).toEqual 0
                    "test unrolled function"
                testFunctionC: -> fail "unexpected call to unroll function c"
                
        run
            description: "subsequent of function"
            expression:
                call: "testFunctionB"
                with: "test arguments"
                starts: "test starts"
                ends: "test ends"
            item: 4
            output: "test unrolled function"
            expressionUnrollFunctions:
                testFunctionA: -> fail "unexpected call to unroll function a"
                testFunctionB: (expression, item) ->
                    (expect expression).toEqual 
                        call: "testFunctionB"
                        with: "test arguments"
                        starts: "test starts"
                        ends: "test ends"
                    (expect item).toEqual 4
                    "test unrolled function"
                testFunctionC: -> fail "unexpected call to unroll function c"