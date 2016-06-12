describe "tokenize", ->
    rewire = require "rewire"
    tokenize = undefined
    beforeEach -> tokenize = rewire "./tokenize"

    describe "imports", ->
        it "tokenizeSplitByWhitespace", -> (expect tokenize.__get__ "tokenizeSplitByWhitespace").toBe require "./tokenize/splitByWhitespace"
        it "tokenizeSplitToken", -> (expect tokenize.__get__ "tokenizeSplitToken").toBe require "./tokenize/splitToken"
        it "tokenizeParenthesize", -> (expect tokenize.__get__ "tokenizeParenthesize").toBe require "./tokenize/parenthesize"
        
    describe "on calling with empty", ->
        it "returns empty", -> (expect tokenize "").toEqual []

    describe "on calling with whitespace", ->
        it "returns empty", -> (expect tokenize "    \n    \t \t   \n  ").toEqual []
        
    describe "on calling", ->
        result = tokenizeParenthesize = tokenizeSplitToken = tokenizeSplitByWhitespace = undefined
        beforeEach ->
            tokenizeSplitByWhitespace = jasmine.createSpy "tokenizeSplitByWhitespace"
            tokenizeSplitByWhitespace.and.returnValue ["test split token a", "test split token b", "test split token c"]
            tokenize.__set__ "tokenizeSplitByWhitespace", tokenizeSplitByWhitespace
            
            tokenizeSplitToken = jasmine.createSpy "tokenizeSplitToken"
            tokenizeSplitToken.and.callFake (token) -> switch token
                when "test split token a" then ["test subtoken a", "test subtoken b"]
                when "test split token b" then ["test subtoken c"]
                when "test split token c" then ["test subtoken d", "test subtoken e", "test subtoken f"]
                else fail "unexpected split of token #{token}"
            tokenize.__set__ "tokenizeSplitToken", tokenizeSplitToken
            
            tokenizeParenthesize = jasmine.createSpy "tokenizeParenthesize"
            tokenizeParenthesize.and.returnValue "test parenthesized tokens"
            tokenize.__set__ "tokenizeParenthesize", tokenizeParenthesize
            
            result = tokenize "test input string"
    
        it "splits the input string by whitespace", ->
            (expect tokenizeSplitByWhitespace.calls.count()).toEqual 1
            (expect tokenizeSplitByWhitespace).toHaveBeenCalledWith "test input string"
            
        it "splits each token returned into subtokens", ->
            (expect tokenizeSplitToken.calls.count()).toEqual 3
            (expect tokenizeSplitToken).toHaveBeenCalledWith "test split token a"
            (expect tokenizeSplitToken).toHaveBeenCalledWith "test split token b"
            (expect tokenizeSplitToken).toHaveBeenCalledWith "test split token c"
            
        it "parenthesizes the split subtokens", ->
            (expect tokenizeParenthesize.calls.count()).toEqual 1
            (expect tokenizeParenthesize).toHaveBeenCalledWith ["test subtoken a", "test subtoken b", "test subtoken c", "test subtoken d", "test subtoken e", "test subtoken f"]
        
        it "returns the parenthesized tokens", ->
            (expect result).toEqual "test parenthesized tokens"