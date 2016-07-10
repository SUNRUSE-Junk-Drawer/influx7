describe "expression", -> describe "unroll", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionUnroll = rewire "./unroll"
        it "expressionUnrollFunctions", -> (expect expressionUnroll.__get__ "expressionUnrollFunctions").toBe require "./unroll/functions"
        it "expressionGetPlurality", -> (expect expressionUnroll.__get__ "expressionGetPlurality").toBe require "./getPlurality"
        it "expressionGetReturnType", -> (expect expressionUnroll.__get__ "expressionGetReturnType").toBe require "./getReturnType"
        it "expressionUnrollConcatenators", -> (expect expressionUnroll.__get__ "expressionUnrollConcatenators").toBe require "./unroll/concatenators"
    describe "on calling", ->
        expressionUnroll = rewire "./unroll"
        expressionUnrollConcatenators = 
            testReturnTypeA: "test concatenator a"
            testReturnTypeB: "test concatenator b"
            testReturnTypeC: "test concatenator c"
        run = (config) -> describe config.description, ->
            result = expressionCopy = expressionUnrollFunctionsCopy = expressionUnrollConcatenatorsCopy = undefined
            beforeEach ->
                expressionUnrollFunctionsCopy = {}
                for key, value of config.expressionUnrollFunctions
                    expressionUnrollFunctionsCopy[key] = value
                expressionUnroll.__set__ "expressionUnrollFunctions", expressionUnrollFunctionsCopy
                expressionUnroll.__set__ "expressionGetPlurality", (expression) ->
                    if config.getsPlurality is undefined
                        fail "unexpected call to getPlurality"
                    else
                        (expect expression).toEqual config.expression
                        config.getsPlurality
                expressionUnroll.__set__ "expressionGetReturnType", (expression) ->
                    if config.getsReturnType is undefined
                        fail "unexpected call to expressionGetReturnType"
                    else
                        (expect expression).toEqual config.expression
                        config.getsReturnType
                expressionUnrollConcatenatorsCopy = JSON.parse JSON.stringify expressionUnrollConcatenators
                expressionUnroll.__set__ "expressionUnrollConcatenators", expressionUnrollConcatenatorsCopy
                expressionCopy = JSON.parse JSON.stringify config.expression
                result = expressionUnroll expressionCopy, config.item
            it "does not modify the input", -> (expect expressionCopy).toEqual config.expression
            it "returns the expected result", -> (expect result).toEqual config.output
            it "does not modify expressionUnrollFunctions", -> (expect expressionUnrollFunctionsCopy).toEqual config.expressionUnrollFunctions
            it "does not modify expressionUnrollConcatenators", -> (expect expressionUnrollConcatenatorsCopy).toEqual expressionUnrollConcatenators
            
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
            description: "concatenation of primitive (null)"
            expression:
                primitive: "test primitive"
                value: "test value"
                starts: "test starts"
                ends: "test ends"
            item: null
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
            description: "concatenation of primitive (undefined)"
            expression:
                primitive: "test primitive"
                value: "test value"
                starts: "test starts"
                ends: "test ends"
            item: undefined
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

        run
            description: "concatenation of function without plurality (null)"
            expression:
                call: "testFunctionB"
                with: "test arguments"
                starts: "test starts"
                ends: "test ends"
            item: null
            output: "test unrolled function"
            getsReturnType: "testReturnTypeB"
            getsPlurality: 1
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
            description: "concatenation of function without plurality (undefined)"
            expression:
                call: "testFunctionB"
                with: "test arguments"
                starts: "test starts"
                ends: "test ends"
            item: undefined
            output: "test unrolled function"
            getsReturnType: "testReturnTypeB"
            getsPlurality: 1
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
            description: "concatenation of function with plurality (null)"
            expression:
                call: "testFunctionB"
                with: "test arguments"
                starts: "test starts"
                ends: "test ends"
            item: null
            output:
                call: "test concatenator b"
                starts: "test starts"
                ends: "test ends"
                with: [
                        call: "test concatenator b"
                        starts: "test starts"
                        ends: "test ends"
                        with: [
                                call: "test concatenator b"
                                starts: "test starts"
                                ends: "test ends"
                                with: [
                                        "test unrolled function a"
                                    ,
                                        "test unrolled function b"
                                ]
                            ,
                                "test unrolled function c"
                        ]
                    ,
                        "test unrolled function d"
                ]
            getsReturnType: "testReturnTypeB"
            getsPlurality: 4
            expressionUnrollFunctions:
                testFunctionA: -> fail "unexpected call to unroll function a"
                testFunctionB: (expression, item) ->
                    (expect expression).toEqual 
                        call: "testFunctionB"
                        with: "test arguments"
                        starts: "test starts"
                        ends: "test ends"
                    switch item
                        when 0 then "test unrolled function a"
                        when 1 then "test unrolled function b"
                        when 2 then "test unrolled function c"
                        when 3 then "test unrolled function d"
                        else fail "unexpected call to unroll function with item #{item}"
                testFunctionC: -> fail "unexpected call to unroll function c"
                
        run
            description: "concatenation of function with plurality (undefined)"
            expression:
                call: "testFunctionB"
                with: "test arguments"
                starts: "test starts"
                ends: "test ends"
            item: undefined
            output:
                call: "test concatenator b"
                starts: "test starts"
                ends: "test ends"
                with: [
                        call: "test concatenator b"
                        starts: "test starts"
                        ends: "test ends"
                        with: [
                                call: "test concatenator b"
                                starts: "test starts"
                                ends: "test ends"
                                with: [
                                        "test unrolled function a"
                                    ,
                                        "test unrolled function b"
                                ]
                            ,
                                "test unrolled function c"
                        ]
                    ,
                        "test unrolled function d"
                ]
            getsReturnType: "testReturnTypeB"
            getsPlurality: 4
            expressionUnrollFunctions:
                testFunctionA: -> fail "unexpected call to unroll function a"
                testFunctionB: (expression, item) ->
                    (expect expression).toEqual 
                        call: "testFunctionB"
                        with: "test arguments"
                        starts: "test starts"
                        ends: "test ends"
                    switch item
                        when 0 then "test unrolled function a"
                        when 1 then "test unrolled function b"
                        when 2 then "test unrolled function c"
                        when 3 then "test unrolled function d"
                        else fail "unexpected call to unroll function with item #{item}"
                testFunctionC: -> fail "unexpected call to unroll function c"