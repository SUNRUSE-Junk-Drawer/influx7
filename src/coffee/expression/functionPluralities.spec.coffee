describe "expression", -> describe "functionPluralities", ->
    functionPluralities = require "./functionPluralities"
    map = (func) -> describe func, -> it "maps to scalars", -> (expect functionPluralities[func]).toBe require "./functionPluralities/map"
    concatenate = (func) -> describe func, -> it "concatenates vectors", -> (expect functionPluralities[func]).toBe require "./functionPluralities/concatenate"
    reduce = (func) -> describe func, -> it "reduces vectors to scalars", -> (expect functionPluralities[func]).toBe require "./functionPluralities/reduce"

    concatenate "concatenate"
    
    map "and"
    map "or"
    map "not"

    map "add"
    map "subtract"
    map "multiply"
    map "divide"
    map "negate"
    
    map "equal"
    map "notEqual"
    
    map "lessThan"
    map "lessThanOrEqual"

    map "greaterThan"
    map "greaterThanOrEqual"
    
    it "maps every function defined", -> 
        for untypedFunction, typedFunctions of require "./functionParameters"
            (expect functionPluralities[untypedFunction]).toEqual (jasmine.any Function), "no plurality for #{untypedFunction}"