describe "expression", -> describe "parse", -> describe "argumentList", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseArgumentList = rewire "./argumentList"
        it "parseList", -> (expect expressionParseArgumentList.__get__ "parseList").toBe require "./../../parseList"
        it "expressionParse", -> (expect expressionParseArgumentList.__get__ "expressionParse").toBe require "./../parse"
    describe "on calling", ->
        expressionParseArgumentList = rewire "./argumentList"
        run = (config) -> describe config.description, ->
            inputCopy = undefined
            beforeEach ->
                expressionParseArgumentList.__set__ "parseList", (tokens, deliminator) ->
                    if config.parsesList
                        (expect tokens).toEqual config.parsesList
                        (expect deliminator).toEqual ","
                        config.parsesListTo
                    else fail "unexpected call to parseList"
                expressionParseArgumentList.__set__ "expressionParse", (tokens, declarations) ->
                    if config.parsesExpressions
                        found = config.parsesExpressions[tokens]
                        (expect found).not.toBeUndefined()
                        (expect declarations).toEqual "test declarations"
                        found
                    else fail "unexpected call to expressionParse"
                inputCopy = JSON.parse JSON.stringify config.input
            if config.throws
                it "throws the expected exception", -> (expect -> expressionParseArgumentList inputCopy, "test declarations").toThrow config.throws
            else
                it "returns the expected output", -> (expect expressionParseArgumentList inputCopy, "test declarations").toEqual config.output
            
            describe "then", ->
                beforeEach ->
                    try
                        expressionParseArgumentList inputCopy, "test declarations"
                    catch e
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
        run
            description: "nothing"
            input:
                token: "("
                starts: 37
                ends: 70
                children: []
            throws:
                reason: "emptyExpression"
                starts: 37
                ends: 70
                
        run
            description: "valid"
            input:
                token: "("
                starts: 37
                ends: 70
                children: ["test argument token a", "test argument token b", "test argument token c", "test argument token d"]
            parsesList: ["test argument token a", "test argument token b", "test argument token c", "test argument token d"]
            parsesListTo: ["testTokenListA", "testTokenListB", "testTokenListC"]
            parsesExpressions:
                testTokenListA: "test parsed argument a"
                testTokenListB: "test parsed argument b"
                testTokenListC: "test parsed argument c"
            output: ["test parsed argument a", "test parsed argument b", "test parsed argument c"]