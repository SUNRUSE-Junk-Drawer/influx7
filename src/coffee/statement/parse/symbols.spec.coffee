describe "statement", -> describe "parse", -> describe "symbols", ->
    statementParseSymbols = require "./symbols"
    
    maps = (symbol, operator) -> it "maps #{symbol} to #{operator}", ->
        (expect symbol in statementParseSymbols[operator]).toBeTruthy()
    
    it "maps every statement", ->
        statements = require "./statements"
        for level in statements
            for func in operators
                (expect statementParseSymbols[func]).not.toBeUndefined()
    
    it "does not contain any ambiguous mappings", ->
        mappings = {}
        for func, keywords of statementParseSymbols
            for keyword in keywords
                mappings[keyword] = func

        for func, keywords of statementParseSymbols
            for keyword in keywords
                (expect mappings[keyword]).toEqual func