describe "expression", -> describe "parse", -> describe "statement", -> describe "functions", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseStatementFunctions = rewire "./functions"
        it "expressionParse", -> (expect expressionParseStatementFunctions.__get__ "expressionParse").toBe require "./../../parse"

    describe "on calling", ->
        expressionParseStatementFunctions = rewire "./functions"
    
        statementToken = 
            token: "test statement token"
            starts: 27
            ends: 65
    
        includes = (name, _then) -> describe name, ->
            _then (config) -> describe config.description, ->
                parsesExpressionCopy = statementTokenCopy = inputCopy = undefined
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
