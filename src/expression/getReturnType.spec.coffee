describe "expression", -> describe "getReturnType", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionGetReturnType = rewire "./getReturnType"
        it "expressionFunctionReturnTypes", -> (expect expressionGetReturnType.__get__ "expressionFunctionReturnTypes").toBe require "./functionReturnTypes"
    describe "on calling", ->
        expressionGetReturnType = rewire "./getReturnType"
        run = (config) ->
            describe config.description, ->
                expressionFunctionReturnTypes = 
                    testFunctionA: "test function a return type"
                    testFunctionB: "test function b return type"
                    testFunctionC: "test function c return type"
                result = inputCopy = expressionFunctionReturnTypesCopy = undefined
                beforeEach ->
                    inputCopy = JSON.parse JSON.stringify config.input
                    expressionFunctionReturnTypesCopy = JSON.parse JSON.stringify expressionFunctionReturnTypes
                    expressionGetReturnType.__set__ "expressionFunctionReturnTypes", expressionFunctionReturnTypesCopy
                    result = expressionGetReturnType inputCopy
                it "returns the expected result", -> (expect result).toEqual config.output
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
                it "does not modify expressionFunctionReturnTypes", -> (expect expressionFunctionReturnTypesCopy).toEqual expressionFunctionReturnTypes
        run
            description: "primitive with truthy value"
            input: 
                primitive: "test primitive type"
                value: "test primitive value"
            output: "test primitive type"
        run
            description: "primitive with falsy value"
            input: 
                primitive: "test primitive type"
                value: false
            output: "test primitive type"
        run
            description: "function call"
            input: 
                call: "testFunctionB"
                with: ["irrelevantTypedArgumentA", "irrelevantTypedArgumentB"]
            output: "test function b return type"