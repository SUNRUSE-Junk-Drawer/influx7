describe "expresion", -> describe "parse", -> describe "operatorKeywords", ->
    expressionOperatorKeywords = require "./operatorKeywords"
    
    maps = (keyword, operator) -> it "maps #{keyword} to #{operator}", ->
        (expect keyword in expressionOperatorKeywords[operator]).toBeTruthy()
    
    maps "and", "and"
    
    maps "or", "or"
    
    maps "not", "not"
    
    maps "is", "equal"
    
    maps "isnt", "notEqual"
    
    it "maps every operator", ->
        operatorPrecedence = require "./operatorPrecedence"
        for level in operatorPrecedence
            for type, operators of level
                for operator in operators
                    (expect expressionOperatorKeywords[operator]).not.toBeUndefined()
    
    it "does not contain any ambiguous mappings", ->
        mappings = 
            binary: []
            unary: []
        operatorPrecedence = require "./operatorPrecedence"
        for level in operatorPrecedence
            for type, operators of level
                for operator in operators
                    for keyword in expressionOperatorKeywords[operator]
                        mappings[type][keyword] = operator
                        
        for level in operatorPrecedence
            for type, operators of level
                for operator in operators
                    for keyword in expressionOperatorKeywords[operator]
                        (expect mappings[type][keyword]).toEqual operator