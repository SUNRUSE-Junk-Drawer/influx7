describe "tree", -> describe "parse", -> describe "operatorPrecedence", ->
    expressionOperatorPrecedence = require "./operatorPrecedence"
    
    indexOf = (type, name) -> 
        for obj, i in expressionOperatorPrecedence
            if name in obj[type] then return i
        -1
    
    maps = (overType, overName, underType, underName) -> 
        it "#{overType} #{overName} over #{underType} #{underName}", ->
            (expect (indexOf overType, overName) < (indexOf underType, underName)).toBeTruthy()
        
    maps "binary", "and", "unary", "not"
    maps "unary", "not", "binary", "or"
    maps "binary", "or", "binary", "equal"
    maps "binary", "or", "binary", "notEqual"
    maps "binary", "or", "binary", "greaterThan"
    maps "binary", "or", "binary", "greaterThanOrEqual"
    maps "binary", "or", "binary", "lessThan"
    maps "binary", "or", "binary", "lessThanOrEqual"
    maps "binary", "equal", "binary", "subtract"
    maps "binary", "notEqual", "binary", "subtract"
    maps "binary", "greaterThan", "binary", "subtract"
    maps "binary", "greaterThanOrEqual", "binary", "subtract"
    maps "binary", "lessThan", "binary", "subtract"
    maps "binary", "lessThanOrEqual", "binary", "subtract"
    maps "binary", "subtract", "binary", "add"
    maps "binary", "add", "binary", "multiply"
    maps "binary", "multiply", "binary", "divide"
    maps "binary", "divide", "unary", "negate"
    
    it "does not contain duplicate operators over multiple levels", ->
        for obj, i in expressionOperatorPrecedence
            for type, operators of obj
                for operator in operators
                    (expect indexOf type, operator).toEqual i
                    
    it "does not contain duplicate operators over the same level", ->
        for obj in expressionOperatorPrecedence
            for type, operators of obj
                for operator, i in operators
                    (expect operators.indexOf operator).toEqual i