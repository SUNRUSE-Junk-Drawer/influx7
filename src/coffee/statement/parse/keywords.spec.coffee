describe "statement", -> describe "parse", -> describe "keywords", ->
    statementParseKeywords = require "./keywords"
    
    maps = (keyword, func) -> it "maps #{keyword} to #{func}", ->
        (expect keyword in statementParseKeywords[func]).toBeTruthy()
    
    maps "function", "function"
    
    it "maps every statement", ->
        statements = require "./statements"
        for level in statements
            for func in operators
                (expect statementParseKeywords[func]).not.toBeUndefined()
    
    it "does not contain any ambiguous mappings", ->
        mappings = {}
        for func, keywords of statementParseKeywords
            for keyword in keywords
                mappings[keyword] = func

        for func, keywords of statementParseKeywords
            for keyword in keywords
                (expect mappings[keyword]).toEqual func