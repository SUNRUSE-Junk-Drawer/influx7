describe "expression", -> describe "functionPluralities", ->
    functionPluralities = require "./functionPluralities"
    map = (func) -> describe func, -> it "maps to scalars", -> (expect functionPluralities[func]).toBe require "./functionPluralities/map"
    concatenate = (func) -> describe func, -> it "concatenates vectors", -> (expect functionPluralities[func]).toBe require "./functionPluralities/concatenate"
    reduce = (func) -> describe func, -> it "reduces vectors to scalars", -> (expect functionPluralities[func]).toBe require "./functionPluralities/reduce"

    concatenate "concatenateBoolean"
    concatenate "concatenateInteger"
    concatenate "concatenateFloat"
    
    map "andBoolean"
    map "orBoolean"
    map "notBoolean"

    map "addFloat"
    map "subtractFloat"
    map "multiplyFloat"
    map "divideFloat"
    map "negateFloat"
    
    map "addInteger"
    map "subtractInteger"
    map "multiplyInteger"
    map "negateInteger"

    map "equalBoolean"
    map "notEqualBoolean"
    
    map "equalInteger"
    map "notEqualInteger"
    
    map "lessThanInteger"
    map "lessThanOrEqualInteger"

    map "greaterThanInteger"
    map "greaterThanOrEqualInteger"
    
    map "equalFloat"
    map "notEqualFloat"
    
    map "lessThanFloat"
    map "lessThanOrEqualFloat"

    map "greaterThanFloat"
    map "greaterThanOrEqualFloat"
    
    it "maps every function defined", -> 
        for untypedFunction, typedFunctions of require "./functionParameters"
            for typedFunction of typedFunctions
                (expect functionPluralities[typedFunction]).toEqual (jasmine.any Function), "no plurality for #{typedFunction}"