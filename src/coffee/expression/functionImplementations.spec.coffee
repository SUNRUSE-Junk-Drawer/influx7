describe "expression", -> describe "functionImplementations", ->
    functionImplementations = require "./functionImplementations"

    currentFunction = undefined
    implementsFunction = (name, _then) ->
        describe name, ->
            beforeEach -> currentFunction = functionImplementations[name]
            _then()
            
    as = (description) ->
        ourArgs = Array.prototype.slice.call(arguments)
        functionArguments = ourArgs[1...-1]
        describe description, ->
            result = functionArgumentsCopy = undefined
            beforeEach ->
                functionArgumentsCopy = JSON.parse JSON.stringify functionArguments
                result = currentFunction.apply null, functionArgumentsCopy
            it "does not modify the inputs", -> (expect functionArgumentsCopy).toEqual functionArguments
            it "returns the expected result", -> (expect result).toEqual ourArgs[ourArgs.length - 1]

    asWithTolerance = (description) ->
        ourArgs = Array.prototype.slice.call(arguments)
        functionArguments = ourArgs[1...-1]
        describe description, ->
            result = functionArgumentsCopy = undefined
            beforeEach ->
                functionArgumentsCopy = JSON.parse JSON.stringify functionArguments
                result = currentFunction.apply null, functionArgumentsCopy
            it "does not modify the inputs", -> (expect functionArgumentsCopy).toEqual functionArguments
            it "returns the expected result", -> (expect result).toBeCloseTo ourArgs[ourArgs.length - 1]
            
    implementsFunction "equalBoolean", ->            
        as "false to false", false, false, true
        as "true to true", true, true, true
        as "true to false", true, false, false
        as "false to true", false, true, false
        
    implementsFunction "notEqualBoolean", ->
        as "false to false", false, false, false
        as "true to true", true, true, false
        as "true to false", true, false, true
        as "false to true", false, true, true
        
    implementsFunction "andBoolean", ->
        as "false to false", false, false, false
        as "true to true", true, true, true
        as "true to false", true, false, false
        as "false to true", false, true, false
        
    implementsFunction "orBoolean", ->
        as "false to false", false, false, false
        as "true to true", true, true, true
        as "true to false", true, false, true
        as "false to true", false, true, true
                            
    implementsFunction "equalInteger", ->
        as "zero to zero", 0, 0, true
        as "zero to positive", 0, 5, false
        as "zero to negative", 0, -5, false
        as "positive to zero", 5, 0, false
        as "negative to zero", -5, 0, false
        as "negative to positive", -5, 5, false
        as "positive to negative", 5, -5, false
        as "positive to positive", 5, 5, true
        as "positive to larger positive", 5, 6, false
        as "positive to smaller positive", 5, 4, false
        as "negative to negative", -5, -5, true
        as "negative to larger negative", -5, -6, false
        as "negative to smaller negative", -5, -4, false
        as "positive to larger negative", 5, -6, false
        as "positive to smaller negative", 5, -4, false
        as "negative to larger positive", -5, 6, false
        as "negative to smaller positive", -5, 4, false
        
    implementsFunction "notEqualInteger", ->
        as "zero to zero", 0, 0, false
        as "zero to positive", 0, 5, true
        as "zero to negative", 0, -5, true
        as "positive to zero", 5, 0, true
        as "negative to zero", -5, 0, true
        as "negative to positive", -5, 5, true
        as "positive to negative", 5, -5, true
        as "positive to positive", 5, 5, false
        as "positive to larger positive", 5, 6, true
        as "positive to smaller positive", 5, 4, true
        as "negative to negative", -5, -5, false
        as "negative to larger negative", -5, -6, true
        as "negative to smaller negative", -5, -4, true
        as "positive to larger negative", 5, -6, true
        as "positive to smaller negative", 5, -4, true
        as "negative to larger positive", -5, 6, true
        as "negative to smaller positive", -5, 4, true
        
    implementsFunction "lessThanOrEqualInteger", ->
        as "zero to zero", 0, 0, true
        as "zero to positive", 0, 5, true
        as "zero to negative", 0, -5, false
        as "positive to zero", 5, 0, false
        as "negative to zero", -5, 0, true
        as "negative to positive", -5, 5, true
        as "positive to negative", 5, -5, false
        as "positive to positive", 5, 5, true
        as "positive to larger positive", 5, 6, true
        as "positive to smaller positive", 5, 4, false
        as "negative to negative", -5, -5, true
        as "negative to larger negative", -5, -6, false
        as "negative to smaller negative", -5, -4, true
        as "positive to larger negative", 5, -6, false
        as "positive to smaller negative", 5, -4, false
        as "negative to larger positive", -5, 6, true
        as "negative to smaller positive", -5, 4, true
        
    implementsFunction "lessThanInteger", ->
        as "zero to zero", 0, 0, false
        as "zero to positive", 0, 5, true
        as "zero to negative", 0, -5, false
        as "positive to zero", 5, 0, false
        as "negative to zero", -5, 0, true
        as "negative to positive", -5, 5, true
        as "positive to negative", 5, -5, false
        as "positive to positive", 5, 5, false
        as "positive to larger positive", 5, 6, true
        as "positive to smaller positive", 5, 4, false
        as "negative to negative", -5, -5, false
        as "negative to larger negative", -5, -6, false
        as "negative to smaller negative", -5, -4, true
        as "positive to larger negative", 5, -6, false
        as "positive to smaller negative", 5, -4, false
        as "negative to larger positive", -5, 6, true
        as "negative to smaller positive", -5, 4, true
        
    implementsFunction "greaterThanOrEqualInteger", ->
        as "zero to zero", 0, 0, true
        as "zero to positive", 0, 5, false
        as "zero to negative", 0, -5, true
        as "positive to zero", 5, 0, true
        as "negative to zero", -5, 0, false
        as "negative to positive", -5, 5, false
        as "positive to negative", 5, -5, true
        as "positive to positive", 5, 5, true
        as "positive to larger positive", 5, 6, false
        as "positive to smaller positive", 5, 4, true
        as "negative to negative", -5, -5, true
        as "negative to larger negative", -5, -6, true
        as "negative to smaller negative", -5, -4, false
        as "positive to larger negative", 5, -6, true
        as "positive to smaller negative", 5, -4, true
        as "negative to larger positive", -5, 6, false
        as "negative to smaller positive", -5, 4, false
        
    implementsFunction "greaterThanInteger", ->
        as "zero to zero", 0, 0, false
        as "zero to positive", 0, 5, false
        as "zero to negative", 0, -5, true
        as "positive to zero", 5, 0, true
        as "negative to zero", -5, 0, false
        as "negative to positive", -5, 5, false
        as "positive to negative", 5, -5, true
        as "positive to positive", 5, 5, false
        as "positive to larger positive", 5, 6, false
        as "positive to smaller positive", 5, 4, true
        as "negative to negative", -5, -5, false
        as "negative to larger negative", -5, -6, true
        as "negative to smaller negative", -5, -4, false
        as "positive to larger negative", 5, -6, true
        as "positive to smaller negative", 5, -4, true
        as "negative to larger positive", -5, 6, false
        as "negative to smaller positive", -5, 4, false
                
    implementsFunction "addInteger", ->
        as "zero by zero", 0, 0, 0
        as "positive by zero", 8, 0, 8
        as "negative by zero", -8, 0, -8
        as "zero by positive", 0, 3, 3
        as "positive by positive", 8, 3, 11
        as "negative by positive", -8, 3, -5
        as "zero by negative", 0, -3, -3
        as "positive by negative", 8, -3, 5
        as "negative by negative", -8, -3, -11
        as "negative by positive creating zero", -8, 8, 0
        as "positive by negative creating zero", 8, -8, 0
            
    implementsFunction "subtractInteger", ->
        as "zero by zero", 0, 0, 0
        as "positive by zero", 8, 0, 8
        as "negative by zero", -8, 0, -8
        as "zero by positive", 0, 3, -3
        as "positive by positive", 8, 3, 5
        as "negative by positive", -8, 3, -11
        as "zero by negative", 0, -3, 3
        as "positive by negative", 8, -3, 11
        as "negative by negative", -8, -3, -5
        as "negative by negative creating zero", -8, -8, 0
        as "positive by positive creating zero", 8, 8, 0
        
    implementsFunction "multiplyInteger", ->
        as "zero by zero", 0, 0, 0
        as "positive by zero", 8, 0, 0
        as "negative by zero", -8, 0, 0
        as "zero by positive", 0, 3, 0
        as "positive by positive", 8, 3, 24
        as "negative by positive", -8, 3, -24
        as "zero by negative", 0, -3, 0
        as "positive by negative", 8, -3,-24
        as "negative by negative", -8, -3, 24
                                
    implementsFunction "equalFloat", ->
        as "zero to zero", 0, 0, true
        as "zero to positive", 0, 4.7, false
        as "zero to negative", 0, -4.7, false
        as "positive to zero", 4.7, 0, false
        as "negative to zero", -4.7, 0, false
        as "negative to positive", -4.7, 4.7, false
        as "positive to negative", 4.7, -4.7, false
        as "positive to positive", 4.7, 4.7, true
        as "positive to larger positive", 4.7, 4.9, false
        as "positive to smaller positive", 4.7, 4.2, false
        as "negative to negative", -4.7, -4.7, true
        as "negative to larger negative", -4.7, -4.9, false
        as "negative to smaller negative", -4.9, -4.7, false
        as "positive to larger negative", 4.7, -4.9, false
        as "positive to smaller negative", 4.7, -4.2, false
        as "negative to larger positive", -4.7, 4.9, false
        as "negative to smaller positive", -4.7, 4.2, false
        
    implementsFunction "notEqualFloat", ->
        as "zero to zero", 0, 0, false
        as "zero to positive", 0, 4.7, true
        as "zero to negative", 0, -4.7, true
        as "positive to zero", 4.7, 0, true
        as "negative to zero", -4.7, 0, true
        as "negative to positive", -4.7, 4.7, true
        as "positive to negative", 4.7, -4.7, true
        as "positive to positive", 4.7, 4.7, false
        as "positive to larger positive", 4.7, 4.9, true
        as "positive to smaller positive", 4.7, 4.2, true
        as "negative to negative", -4.7, -4.7, false
        as "negative to larger negative", -4.7, -4.9, true
        as "negative to smaller negative", -4.7, -4, true
        as "positive to larger negative", 4.7, -4.9, true
        as "positive to smaller negative", 4.7, -4, true
        as "negative to larger positive", -4.7, 4.9, true
        as "negative to smaller positive", -4.7, 4.2, true
        
    implementsFunction "lessThanOrEqualFloat", ->
        as "zero to zero", 0, 0, true
        as "zero to positive", 0, 4.7, true
        as "zero to negative", 0, -4.7, false
        as "positive to zero", 4.7, 0, false
        as "negative to zero", -4.7, 0, true
        as "negative to positive", -4.7, 4.7, true
        as "positive to negative", 4.7, -4.7, false
        as "positive to positive", 4.7, 4.7, true
        as "positive to larger positive", 4.7, 4.9, true
        as "positive to smaller positive", 4.7, 4.2, false
        as "negative to negative", -4.7, -4.7, true
        as "negative to larger negative", -4.7, -4.9, false
        as "negative to smaller negative", -4.7, -4.2, true
        as "positive to larger negative", 4.7, -4.9, false
        as "positive to smaller negative", 4.7, -4.2, false
        as "negative to larger positive", -4.7, 4.9, true
        as "negative to smaller positive", -4.7, 4.2, true
        
    implementsFunction "lessThanFloat", ->
        as "zero to zero", 0, 0, false
        as "zero to positive", 0, 4.7, true
        as "zero to negative", 0, -4.7, false
        as "positive to zero", 4.7, 0, false
        as "negative to zero", -4.7, 0, true
        as "negative to positive", -4.7, 4.7, true
        as "positive to negative", 4.7, -4.7, false
        as "positive to positive", 4.7, 4.7, false
        as "positive to larger positive", 4.7, 4.9, true
        as "positive to smaller positive", 4.7, 4.2, false
        as "negative to negative", -4.7, -4.7, false
        as "negative to larger negative", -4.7, -4.9, false
        as "negative to smaller negative", -4.7, -4.2, true
        as "positive to larger negative", 4.7, -4.9, false
        as "positive to smaller negative", 4.7, -4.2, false
        as "negative to larger positive", -4.7, 4.9, true
        as "negative to smaller positive", -4.7, 4.2, true
        
    implementsFunction "greaterThanOrEqualFloat", ->
        as "zero to zero", 0, 0, true
        as "zero to positive", 0, 4.7, false
        as "zero to negative", 0, -4.7, true
        as "positive to zero", 4.7, 0, true
        as "negative to zero", -4.7, 0, false
        as "negative to positive", -4.7, 4.7, false
        as "positive to negative", 4.7, -4.7, true
        as "positive to positive", 4.7, 4.7, true
        as "positive to larger positive", 4.7, 4.9, false
        as "positive to smaller positive", 4.7, 4.2, true
        as "negative to negative", -4.7, -4.7, true
        as "negative to larger negative", -4.7, -4.9, true
        as "negative to smaller negative", -4.7, -4.2, false
        as "positive to larger negative", 4.7, -4.9, true
        as "positive to smaller negative", 4.7, -4.2, true
        as "negative to larger positive", -4.7, 4.9, false
        as "negative to smaller positive", -4.7, 4.2, false
        
    implementsFunction "greaterThanFloat", ->
        as "zero to zero", 0, 0, false
        as "zero to positive", 0, 4.7, false
        as "zero to negative", 0, -4.7, true
        as "positive to zero", 4.7, 0, true
        as "negative to zero", -4.7, 0, false
        as "negative to positive", -4.7, 4.7, false
        as "positive to negative", 4.7, -4.7, true
        as "positive to positive", 4.7, 4.7, false
        as "positive to larger positive", 4.7, 4.9, false
        as "positive to smaller positive", 4.7, 4.2, true
        as "negative to negative", -4.7, -4.7, false
        as "negative to larger negative", -4.7, -4.9, true
        as "negative to smaller negative", -4.7, -4.2, false
        as "positive to larger negative", 4.7, -4.9, true
        as "positive to smaller negative", 4.7, -4.2, true
        as "negative to larger positive", -4.7, 4.9, false
        as "negative to smaller positive", -4.7, 4.2, false
                
    implementsFunction "addFloat", ->
        asWithTolerance "zero by zero", 0, 0, 0
        asWithTolerance "positive by zero", 4.7, 0, 4.7
        asWithTolerance "negative by zero", -4.7, 0, -4.7
        asWithTolerance "zero by positive", 0, 4.7, 4.7
        asWithTolerance "positive by positive", 4.7, 8.2, 12.9
        asWithTolerance "negative by positive", -4.7, 8.2, 3.5
        asWithTolerance "zero by negative", 0, -3.5, -3.5
        asWithTolerance "positive by negative", 4.7, -3.5, 1.2
        asWithTolerance "negative by negative", -4.7, -3.5, -8.2
        asWithTolerance "negative by positive creating zero", -8.3, 8.3, 0
        asWithTolerance "positive by negative creating zero", 8.3, -8.3, 0
    
    implementsFunction "subtractFloat", ->
        asWithTolerance "zero by zero", 0, 0, 0
        asWithTolerance "positive by zero", 4.3, 0, 4.3
        asWithTolerance "negative by zero", -4.3, 0, -4.3
        asWithTolerance "zero by positive", 0, 4.3, -4.3
        asWithTolerance "positive by positive", 7.6, 4.3, 3.3
        asWithTolerance "negative by positive", -7.6, 4.3, -11.9
        asWithTolerance "zero by negative", 0, -4.3, 4.3
        asWithTolerance "positive by negative", 7.6, -4.3, 11.9
        asWithTolerance "negative by negative", -7.6, -4.3, -3.3
        asWithTolerance "negative by negative creating zero", -4.3, -4.3, 0
        asWithTolerance "positive by positive creating zero", 4.3, 4.3, 0
    
    implementsFunction "multiplyFloat", ->
        asWithTolerance "zero by zero", 0, 0, 0
        asWithTolerance "positive by zero", 8.3, 0, 0
        asWithTolerance "negative by zero", -8.3, 0, 0
        asWithTolerance "zero by positive", 0, 3.4, 0
        asWithTolerance "positive by positive", 8.3, 3.4, 28.22
        asWithTolerance "negative by positive", -8.3, 3.4, -28.22
        asWithTolerance "zero by negative", 0, -3.4, 0
        asWithTolerance "positive by negative", 8.3, -3.4,-28.22
        asWithTolerance "negative by negative", -8.3, -3.4, 28.22

    implementsFunction "divideFloat", ->
        # Divide by zero is undefined behaviour.
        asWithTolerance "zero by positive", 0, 4.5, 0
        asWithTolerance "positive by positive", 8.1, 4.5, 1.8
        asWithTolerance "negative by positive", -8.1, 4.5, -1.8
        asWithTolerance "zero by negative", 0, -4.5, 0
        asWithTolerance "positive by negative", 8.1, -4.5, -1.8
        asWithTolerance "negative by negative", -8.1, -4.5, 1.8
    
    implementsFunction "negateInteger", ->
        as "zero", 0, 0
        as "positive", 4, -4
        as "negative", -4, 4
                
    implementsFunction "negateFloat", ->
        asWithTolerance "zero", 0, 0
        asWithTolerance "positive", 4.5, -4.5
        asWithTolerance "negative", -4.5, 4.5
                
    implementsFunction "notBoolean", ->
        as "false", false, true
        as "true", true, false
        
    implementsFunction "concatenateBoolean", ->
        as "", [false, true, true], [true, false], [false, true, true, true, false]

    implementsFunction "concatenateInteger", ->
        as "", [3, -4, 7], [-1, 8], [3, -4, 7, -1, 8]
        
    implementsFunction "concatenateFloat", ->
        as "", [3.7, -4.2, 7.6], [-1.4, 8.9], [3.7, -4.2, 7.6, -1.4, 8.9]
        
    implementsFunction "anyBoolean", ->
        as "false", [false], false
        as "true", [true], true
        
        as "false false false", [false, false, false], false
        as "true false false", [true, false, false], true
        as "false true false", [false, true, false], true
        as "true true false", [true, true, false], true
        as "false false true", [false, false, true], true
        as "true false true", [true, false, true], true
        as "false true true", [false, true, true], true
        as "true true true", [true, true, true], true
        
    implementsFunction "allBoolean", ->
        as "false", [false], false
        as "true", [true], true
        
        as "false false false", [false, false, false], false
        as "true false false", [true, false, false], false
        as "false true false", [false, true, false], false
        as "true true false", [true, true, false], false
        as "false false true", [false, false, true], false
        as "true false true", [true, false, true], false
        as "false true true", [false, true, true], false
        as "true true true", [true, true, true], true
        
    implementsFunction "sumInteger", ->
        as "single zero", [0], 0
        as "single positive", [47], 47
        as "single negative", [-47], -47
        
        as "multiple to positive", [47, -36, 12], 23
        as "multiple to zero", [47, -36, -11], 0
        as "multiple to negative", [47, -36, -21], -10
        
    implementsFunction "sumFloat", ->
        as "single zero", [0], 0
        as "single positive", [4.7], 4.7
        as "single negative", [-4.7], -4.7
        
        as "multiple to positive", [4.7, -3.6, 1.2], 2.3
        as "multiple to zero", [4.7, -3.6, -1.1], 0.0
        as "multiple to negative", [4.7, -3.6, -2.1], -1.0
        
    implementsFunction "productInteger", ->
        as "single zero", [0], 0
        as "single positive", [47], 47
        as "single negative", [-47], -47
        
        as "multiple to positive", [47, -36, 12], -20304
        as "multiple to negative", [47, -36, -12], 20304
        
    implementsFunction "productFloat", ->
        as "single zero", [0], 0
        as "single positive", [4.7], 4.7
        as "single negative", [-4.7], -4.7
        
        asWithTolerance "multiple to positive", [4.7, -36.0, 1.2], -203.04
        asWithTolerance "multiple to negative", [4.7, -36.0, -1.2], 203.04
        
    it "implements every function", ->
        for untypedFunction, typedFunctions of require "./functionParameters"
            for typedFunction of typedFunctions
                (expect functionImplementations[typedFunction]).toEqual (jasmine.any Function), "No mapping of function #{typedFunction}"