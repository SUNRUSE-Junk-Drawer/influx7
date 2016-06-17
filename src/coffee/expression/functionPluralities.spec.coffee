describe "expression", -> describe "functionPluralities", ->
    functionPluralities = require "./functionPluralities"
    map = (func, type) -> describe func, -> it "maps to scalars", -> (expect functionPluralities[func]).toEqual "map"
    concatenate = (func, type) -> describe func, -> it "concatenates vectors", -> (expect functionPluralities[func]).toEqual "concatenate"
    fixed = (func, input, output) -> describe func, ->
        it "takes the correct number of items", -> (expect functionPluralities[func].input).toEqual input
        it "returns the correct number of items", -> (expect functionPluralities[func].output).toEqual output

    concatenate "concatenateBoolean"
    concatenate "concatenateInteger"
    concatenate "concatenateFloat"
    
    map "andBoolean", "map"
    map "orBoolean", "map"
    map "notBoolean", "map"

    map "addFloat", "map"
    map "addInteger", "map"
    map "subtractFloat", "map"
    map "subtractInteger", "map"
    map "multiplyFloat", "map"
    map "multiplyInteger", "map"
    map "divideFloat", "map"
    map "negateFloat", "map"
    map "negateInteger", "map"
    
    map "equalBoolean", "map"
    map "equalFloat", "map"
    map "equalInteger", "map"
    map "notEqualBoolean", "map"
    map "notEqualFloat", "map"
    map "notEqualInteger", "map"
    
    map "lessThanFloat", "map"
    map "lessThanInteger", "map"
    map "lessThanOrEqualFloat", "map"
    map "lessThanOrEqualInteger", "map"

    map "greaterThanFloat", "map"
    map "greaterThanInteger", "map"
    map "greaterThanOrEqualFloat", "map"
    map "greaterThanOrEqualInteger", "map"
    
    it "mapevery function defined", -> 
        for untypedFunction, typedFunctions of require "./functionParameters"
            for typedFunction, parameters of typedFunctions
                (expect functionPluralities[typedFunction]).toEqual (jasmine.any String), "no plurality for #{typedFunction}"