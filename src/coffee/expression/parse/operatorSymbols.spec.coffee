describe "expression", -> describe "parse", -> describe "operatorSymbols", ->
    expressionOperatorSymbols = require "./operatorSymbols"
    
    maps = (symbol, operator) -> it "maps #{symbol} to #{operator}", ->
        (expect symbol in expressionOperatorSymbols[operator]).toBeTruthy()
    
    maps ",", "concatenate"
    
    maps "+", "add"
    maps "-", "subtract"
    maps "-", "negate"
    maps "*", "multiply"
    maps "/", "divide"
    
    maps "&", "and"
    maps "&&", "and"
    
    maps "|", "or"
    maps "||", "or"
    
    maps "!", "not"
    
    maps "=", "equal"
    maps "==", "equal"
    
    maps "<>", "notEqual"
    maps "!=", "notEqual"
    
    maps "<", "lessThan"
    maps "<=", "lessThanOrEqual"   
   
    maps ">", "greaterThan"
    maps ">=", "greaterThanOrEqual"
    
    it "maps every operator", ->
        operatorPrecedence = require "./operatorPrecedence"
        for level in operatorPrecedence
            for type, operators of level
                for operator in operators
                    (expect expressionOperatorSymbols[operator]).not.toBeUndefined()
    
    it "does not contain any ambiguous mappings", ->
        mappings = 
            binary: []
            unary: []
        operatorPrecedence = require "./operatorPrecedence"
        for level in operatorPrecedence
            for type, operators of level
                for operator in operators
                    for symbol in expressionOperatorSymbols[operator]
                        mappings[type][symbol] = operator
                        
        for level in operatorPrecedence
            for type, operators of level
                for operator in operators
                    for symbol in expressionOperatorSymbols[operator]
                        (expect mappings[type][symbol]).toEqual operator