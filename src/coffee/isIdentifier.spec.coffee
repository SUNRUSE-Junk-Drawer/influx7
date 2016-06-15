describe "isIdentifier", ->
    rewire = require "rewire"
    describe "imports", ->
        isIdentifier = rewire "./isIdentifier"
        it "tokenizeKeywords", -> (expect isIdentifier.__get__ "tokenizeKeywords").toBe require "./tokenize/keywords"
        it "tokenizeSymbols", -> (expect isIdentifier.__get__ "tokenizeSymbols").toBe require "./tokenize/symbols"
    describe "on calling", ->
        isIdentifier = rewire "./isIdentifier"
        tokenizeKeywords = ["testkeyworda", "testkeywordb", "testkeywordc"]
        tokenizeSymbols = ["testsymbola", "testsymbolb", "testsymbolc"]
        run = (config) ->
            describe config.description, ->
                result = tokenizeKeywordsCopy = tokenizeSymbolsCopy = undefined
                beforeEach -> 
                    tokenizeKeywordsCopy = JSON.parse JSON.stringify tokenizeKeywords
                    isIdentifier.__set__ "tokenizeKeywords", tokenizeKeywordsCopy
                    tokenizeSymbolsCopy = JSON.parse JSON.stringify tokenizeSymbols
                    isIdentifier.__set__ "tokenizeSymbols", tokenizeSymbolsCopy
                    result = isIdentifier config.input
                it "returns the expected result", -> (expect result).toEqual config.output
                it "does not modify the keywords", -> (expect tokenizeKeywordsCopy).toEqual tokenizeKeywords
                it "does not modify the symbols", -> (expect tokenizeSymbolsCopy).toEqual tokenizeSymbols
        run
            description: "undefined"
            input: undefined
            output: false
        run
            description: "null"
            input: null
            output: false
        run
            description: "empty"
            input: ""
            output: false
        run
            description: "one number"
            input: "5"
            output: false
        run
            description: "one symbol"
            input: "$"
            output: false
        run
            description: "one letter"
            input: "f"
            output: true
        run
            description: "multiple letters"
            input: "fery"
            output: true
        run
            description: "multiple numbers"
            input: "38479"
            output: false
        run 
            description: "one letter followed by multiple numbers"
            input: "f2346"
            output: true
        run 
            description: "one letter followed by a mixture of letters and numbers"
            input: "f4f8f768g7"
            output: true
        run 
            description: "one number followed by letters"
            input: "5wldij"
            output: false
        run 
            description: "one number followed by a mixture of letters and numbers"
            input: "44f8f768g7"
            output: false
        run 
            description: "one letter followed by a mixture of letters and numbers and a symbol"
            input: "f4f8f7$68g7"
            output: false
        run
            description: "a keyword"
            input: "testkeywordb"
            output: false
        run
            description: "a symbol"
            input: "testsymbolb"
            output: false