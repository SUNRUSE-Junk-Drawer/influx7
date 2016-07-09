describe "expression", -> describe "unroll", -> describe "functions", ->
    expressionUnrollFunctions = require "./functions"

    map = (name) -> describe name, ->
        it "uses \"map\" unrolling", -> (expect expressionUnrollFunctions[name]).toBe require "./map"
        
    map "addInteger"
    map "subtractInteger"
    map "multiplyInteger"
    map "negateInteger"
    
    map "equalInteger"
    map "notEqualInteger"
    map "greaterThanInteger"
    map "greaterThanOrEqualInteger"
    map "lessThanInteger"
    map "lessThanOrEqualInteger"
        
    map "addFloat"
    map "subtractFloat"
    map "multiplyFloat"
    map "divideFloat"
    map "negateFloat"
    
    map "equalFloat"
    map "notEqualFloat"
    map "greaterThanFloat"
    map "greaterThanOrEqualFloat"
    map "lessThanFloat"
    map "lessThanOrEqualFloat"
    
    map "equalBoolean"
    map "notEqualBoolean"
    map "notBoolean"
    map "andBoolean"
    map "orBoolean"
    
    concatenate = (name) -> describe name, ->
        it "uses \"concatenate\" unrolling", -> (expect expressionUnrollFunctions[name]).toBe require "./concatenate"

    concatenate "concatenateFloat"
    concatenate "concatenateInteger"
    concatenate "concatenateBoolean"
        
    it "maps every typed function", ->
        for untypedFunction, typedFunctions of require "./../functionParameters"
            for typedFunction of typedFunctions
                (expect expressionUnrollFunctions[typedFunction]).toEqual (jasmine.any Function), "#{typedFunction} is unmapped"