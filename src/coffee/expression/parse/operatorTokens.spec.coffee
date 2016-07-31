describe "expression", -> describe "parse", -> describe "operatorTokens", ->
    expressionOperatorTokens = require "./operatorTokens"
    
    maps = (token, operator) -> it "maps #{token} to #{operator}", ->
        (expect token in expressionOperatorTokens[operator]).toBeTruthy()
    
    maps ",", "concatenate"
    
    maps "+", "add"
    maps "-", "subtract"
    maps "-", "negate"
    maps "*", "multiply"
    maps "/", "divide"
    
    maps "and", "and"
    maps "&", "and"
    maps "&&", "and"
    
    maps "or", "or"
    maps "|", "or"
    maps "||", "or"
    
    maps "not", "not"
    maps "!", "not"
    
    maps "is", "equal"
    maps "=", "equal"
    maps "==", "equal"
    
    maps "isnt", "notEqual"
    maps "<>", "notEqual"
    maps "!=", "notEqual"
    
    maps "<", "lessThan"
    maps "<=", "lessThanOrEqual"   
   
    maps ">", "greaterThan"
    maps ">=", "greaterThanOrEqual"
    
    maps "any", "any"
    maps "all", "all"
    maps "sum", "sum"
    maps "product", "product"
    
    it "maps every operator", ->
        operatorPrecedence = require "./operatorPrecedence"
        for level in operatorPrecedence
            for type, operators of level
                for operator in operators
                    (expect expressionOperatorTokens[operator]).not.toBeUndefined()
    
    it "does not contain any ambiguous mappings", ->
        mappings = 
            binary: []
            unary: []
        operatorPrecedence = require "./operatorPrecedence"
        for level in operatorPrecedence
            for type, operators of level
                for operator in operators
                    for token in expressionOperatorTokens[operator]
                        mappings[type][token] = operator
                        
        for level in operatorPrecedence
            for type, operators of level
                for operator in operators
                    for token in expressionOperatorTokens[operator]
                        (expect mappings[type][token]).toEqual operator