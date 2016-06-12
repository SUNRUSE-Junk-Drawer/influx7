describe "expression", -> describe "parse", -> describe "integer", ->
    rewire = require "rewire"
    describe "on calling", ->
        expressionParseInteger = rewire "./integer"
        
        run = (config) ->
            describe config.description, ->
                result = inputCopy = undefined
                
                beforeEach ->                    
                    inputCopy = JSON.parse JSON.stringify config.input
                    result = expressionParseInteger inputCopy
                
                it "returns the expected result", -> (expect result).toEqual config.output    
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
        run
            description: "multiple tokens"
            input: [
                    token: "0"
                    starts: 35
                    ends: 74
                ,
                    token: "0"
            ]
            output: null
        run
            description: "zero"
            input: [
                token: "0"
                starts: 35
                ends: 74
            ]
            output:
                primitive: "integer"
                value: 0
                starts: 35
                ends: 74
        run
            description: "multiple zeroes"
            input: [
                token: "000"
                starts: 35
                ends: 74
            ]
            output:
                primitive: "integer"
                value: 0
                starts: 35
                ends: 74
        run
            description: "single digit"
            input: [
                token: "4"
                starts: 35
                ends: 74
            ]
            output:
                primitive: "integer"
                value: 4
                starts: 35
                ends: 74
        run
            description: "multiple digits"
            input: [
                token: "478"
                starts: 35
                ends: 74
            ]
            output:
                primitive: "integer" 
                value: 478
                starts: 35
                ends: 74
        run
            description: "single digit preceded by zeroes"
            input: [
                token: "004"
                starts: 35
                ends: 74
            ]
            output:
                primitive: "integer" 
                value: 4
                starts: 35
                ends: 74
        run
            description: "multiple digits preceded by zeroes"
            input: [
                token: "00478"
                starts: 35
                ends: 74
            ]
            output:
                primitive: "integer" 
                value: 478
                starts: 35
                ends: 74
        run
            description: "single digit followed by zeroes"
            input: [
                token: "400"
                starts: 35
                ends: 74
            ]
            output:
                primitive: "integer" 
                value: 400
                starts: 35
                ends: 74
        run
            description: "multiple digits followed by zeroes"
            input: [
                token: "47800"
                starts: 35
                ends: 74
            ]
            output:
                primitive: "integer" 
                value: 47800
                starts: 35
                ends: 74
        run
            description: "non-digit before digit"
            input: [
                token: "t0"
                starts: 35
                ends: 74
            ]
            output: null
        run
            description: "non-digit after digit"
            input: [
                token: "0t"
                starts: 35
                ends: 74
            ]
            output: null

        run
            description: "non-digit between digits"
            input: [
                token: "4t5"
                starts: 35
                ends: 74
            ]
            output: null