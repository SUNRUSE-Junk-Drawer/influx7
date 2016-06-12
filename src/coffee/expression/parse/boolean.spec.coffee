describe "expression", -> describe "parse", -> describe "boolean", ->
    rewire = require "rewire"
    describe "on calling", ->
        expressionParseBoolean = rewire "./boolean"
        run = (config) ->
            describe config.description, ->
                result = inputCopy = undefined
                beforeEach ->                    
                    inputCopy = JSON.parse JSON.stringify config.input
                    result = expressionParseBoolean inputCopy
                it "returns the expected result", -> (expect result).toEqual config.output    
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
        run
            description: "false"
            input: [
                token: "false"
                starts: 30
                ends: 75
            ]
            output:
                primitive: "boolean"
                value: false
                starts: 30
                ends: 75
        run
            description: "true"
            input: [
                token: "true"
                starts: 30
                ends: 75
            ]
            output:
                primitive: "boolean"
                value: true
                starts: 30
                ends: 75
        run
            description: "multiple tokens"
            input: [
                    token: "true"
                    starts: 30
                    ends: 75
                ,
                    token: "true"
                    starts: 82
                    ends: 96
            ]
            output: null