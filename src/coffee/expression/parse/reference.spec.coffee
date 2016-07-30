describe "expression", -> describe "parse", -> describe "reference", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseReference = rewire "./reference"
        it "isIdentifier", -> (expect expressionParseReference.__get__ "isIdentifier").toBe require "./../../isIdentifier"
    describe "on calling", ->
        expressionParseReference = rewire "./reference"
        run = (config) -> describe config.description, ->
            result = inputCopy = undefined
            beforeEach ->
                inputCopy = JSON.parse JSON.stringify config.input
                expressionParseReference.__set__ "isIdentifier", (token) -> switch token
                    when "validIdentifierA", "validIdentifierB" then true
                    when "invalidIdentifierA", "invalidIdentifierB" then false
                    else fail "unexpected call to isIdentifier #{token}"
                result = expressionParseReference inputCopy
            it "does not modify the input", -> (expect inputCopy).toEqual config.input
            it "returns the expected object", -> (expect result).toEqual config.output
            
        run
            description: "nothing"
            input: []
            output: null
            
        run
            description: "one token which is not a valid identifier"
            input: [
                token: "invalidIdentifierA"
                starts: 31
                ends: 74
            ]
            output: null
            
        run
            description: "one token which is a valid identifier"
            input: [
                token: "validIdentifierA"
                starts: 31
                ends: 74
            ]
            output:
                reference: "validIdentifierA"
                starts: 31
                ends: 74
            
        run
            description: "two tokens which are not valid identifiers"
            input: [
                    token: "invalidIdentifierA"
                    starts: 31
                    ends: 74
                ,
                    token: "invalidIdentifierB"
                    starts: 89
                    ends: 114
            ]
            output: null
            
        run
            description: "two tokens which are valid identifiers"
            input: [
                    token: "validIdentifierA"
                    starts: 31
                    ends: 74
                ,
                    token: "validIdentifierB"
                    starts: 89
                    ends: 114
            ]
            output: null
            
        run
            description: "a token which is not a valid identifier followed by one which is"
            input: [
                    token: "invalidIdentifierA"
                    starts: 31
                    ends: 74
                ,
                    token: "validIdentifierA"
                    starts: 89
                    ends: 114
            ]
            output: null
            
        run
            description: "a token which is a valid identifier followed by one which is not"
            input: [
                    token: "validIdentifierA"
                    starts: 31
                    ends: 74
                ,
                    token: "invalidIdentifierA"
                    starts: 89
                    ends: 114
            ]
            output: null