describe "expression", -> describe "functionReturnTypes", ->
    functionReturnTypes = require "./functionReturnTypes"
    maps = (func, type) -> it "maps #{func} to #{type}", -> (expect functionReturnTypes[func]).toEqual type

    maps "concatenateBoolean", "boolean"
    maps "concatenateInteger", "integer"
    maps "concatenateFloat", "float"
    
    maps "andBoolean", "boolean"
    maps "orBoolean", "boolean"
    maps "notBoolean", "boolean"

    maps "addFloat", "float"
    maps "addInteger", "integer"
    maps "subtractFloat", "float"
    maps "subtractInteger", "integer"
    maps "multiplyFloat", "float"
    maps "multiplyInteger", "integer"
    maps "divideFloat", "float"
    maps "negateFloat", "float"
    maps "negateInteger", "integer"
    
    maps "equalBoolean", "boolean"
    maps "equalFloat", "boolean"
    maps "equalInteger", "boolean"
    maps "notEqualBoolean", "boolean"
    maps "notEqualFloat", "boolean"
    maps "notEqualInteger", "boolean"
    
    maps "lessThanFloat", "boolean"
    maps "lessThanInteger", "boolean"
    maps "lessThanOrEqualFloat", "boolean"
    maps "lessThanOrEqualInteger", "boolean"

    maps "greaterThanFloat", "boolean"
    maps "greaterThanInteger", "boolean"
    maps "greaterThanOrEqualFloat", "boolean"
    maps "greaterThanOrEqualInteger", "boolean"
    
    it "maps every function defined", -> 
        for untypedFunction, typedFunctions of require "./functionParameters"
            for typedFunction, parameters of typedFunctions
                (expect functionReturnTypes[typedFunction]).toEqual (jasmine.any String), "no return type for #{typedFunction}"