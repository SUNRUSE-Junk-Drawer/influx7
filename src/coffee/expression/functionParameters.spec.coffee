describe "expression", -> describe "functionParameters", ->
    expressionFunctionParameters = require "./functionParameters"

    maps = (input, parameters, output) -> 
        it "maps #{input} to #{output} when parameters #{JSON.stringify parameters} are given", ->
            (expect expressionFunctionParameters[input][output]).toEqual parameters

    maps "concatenate", ["float", "float"], "concatenateFloat"
    maps "concatenate", ["integer", "integer"], "concatenateInteger"
    maps "concatenate", ["boolean", "boolean"], "concatenateBoolean"
            
    maps "and", ["boolean", "boolean"], "andBoolean"
    maps "or", ["boolean", "boolean"], "orBoolean"
    maps "not", ["boolean"], "notBoolean"

    maps "add", ["integer", "integer"], "addInteger"
    maps "add", ["float", "float"], "addFloat"    
    maps "subtract", ["integer", "integer"], "subtractInteger"
    maps "subtract", ["float", "float"], "subtractFloat"
    maps "multiply", ["integer", "integer"], "multiplyInteger"
    maps "multiply", ["float", "float"], "multiplyFloat"
    maps "divide", ["float", "float"], "divideFloat"
    maps "negate", ["integer"], "negateInteger"
    maps "negate", ["float"], "negateFloat"
    
    maps "equal", ["boolean", "boolean"], "equalBoolean"
    maps "equal", ["integer", "integer"], "equalInteger"
    maps "equal", ["float", "float"], "equalFloat"
    
    maps "notEqual", ["boolean", "boolean"], "notEqualBoolean"
    maps "notEqual", ["integer", "integer"], "notEqualInteger"
    maps "notEqual", ["float", "float"], "notEqualFloat"
    
    maps "lessThan", ["integer", "integer"], "lessThanInteger"
    maps "lessThan", ["float", "float"], "lessThanFloat"
    maps "lessThanOrEqual", ["integer", "integer"], "lessThanOrEqualInteger"
    maps "lessThanOrEqual", ["float", "float"], "lessThanOrEqualFloat"

    maps "greaterThan", ["integer", "integer"], "greaterThanInteger"
    maps "greaterThan", ["float", "float"], "greaterThanFloat"
    maps "greaterThanOrEqual", ["integer", "integer"], "greaterThanOrEqualInteger"
    maps "greaterThanOrEqual", ["float", "float"], "greaterThanOrEqualFloat"
    
    maps "all", ["boolean"], "allBoolean"
    maps "any", ["boolean"], "anyBoolean"
    maps "sum", ["integer"], "sumInteger"
    maps "product", ["integer"], "productInteger"
    maps "sum", ["float"], "sumFloat"
    maps "product", ["float"], "productFloat"
    
    it "maps every function defined as an operator", -> 
        for operator, symbols of require "./parse/operatorSymbols"
            (expect expressionFunctionParameters[operator]).not.toBeUndefined()