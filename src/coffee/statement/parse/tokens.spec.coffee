describe "statement", -> describe "parse", -> describe "tokens", ->
    statementParseTokens = require "./tokens"
    
    maps = (token, operator) -> it "maps #{token} to #{operator}", ->
        (expect token in statementParseTokens[operator]).toBeTruthy()
        
    maps "function", "function"
    
    it "maps every statement", ->
        statements = require "./statements"
        for level in statements
            for func in operators
                (expect statementParseTokens[func]).not.toBeUndefined()
    
    it "does not contain any ambiguous mappings", ->
        mappings = {}
        for func, keywords of statementParseTokens
            for keyword in keywords
                mappings[keyword] = func

        for func, keywords of statementParseTokens
            for keyword in keywords
                (expect mappings[keyword]).toEqual func