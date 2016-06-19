describe "expression", -> describe "functionPluralities", -> describe "map", ->
    map = require "./map"
    run = (config) -> describe config.description, ->
        inputCopy = undefined
        beforeEach -> inputCopy = JSON.parse JSON.stringify config.input
    
        if config.throws
            it "throws the expected exception", -> (expect -> map inputCopy, 37, 86).toThrow config.throws
        else
            it "returns the expected result", -> (expect map inputCopy, 37, 86).toEqual config.output
            
        beforeEach ->
            try
                map inputCopy, 37, 86
        
        it "does not modify the input", -> (expect inputCopy).toEqual config.input
    run
        description: "one argument with a plurality of one"
        input: [1]
        output: 1
        
    run
        description: "one argument with a plurality of greater than one"
        input: [5]
        output: 5
        
    run
        description: "multiple arguments where all have a plurality of one"
        input: [1, 1, 1, 1]
        output: 1
        
    run
        description: "multiple arguments where all have all but the first have a plurality of one"
        input: [5, 1, 1, 1]
        output: 5
        
    run
        description: "multiple arguments where all have all but the middle has a plurality of one"
        input: [1, 5, 1, 1]
        output: 5
        
    run
        description: "multiple arguments where all have all but the last have a plurality of one"
        input: [1, 1, 1, 5]
        output: 5
        
    run
        description: "multiple arguments where all have all but the first have a plurality other than one"
        input: [1, 5, 5, 5]
        output: 5
        
    run
        description: "multiple arguments where all have all but the middle have a plurality other than one"
        input: [5, 1, 5, 5]
        output: 5
        
    run
        description: "multiple arguments where all have all but the last have a plurality other than one"
        input: [5, 5, 5, 1]
        output: 5
        
    run
        description: "multiple arguments where the first has an inconsistent plurality"
        input: [5, 3, 3, 3]
        throws:
            reason: "inconsistentPlurality"
            starts: 37
            ends: 86
        
    run
        description: "multiple arguments where the middle has an inconsistent plurality"
        input: [3, 5, 3, 3]
        throws:
            reason: "inconsistentPlurality"
            starts: 37
            ends: 86
        
    run
        description: "multiple arguments where the last has an inconsistent plurality"
        input: [3, 3, 3, 5]
        throws:
            reason: "inconsistentPlurality"
            starts: 37
            ends: 86
        
    run
        description: "multiple arguments where the first and middle have inconsistent plurality"
        input: [3, 5, 1, 1]
        throws:
            reason: "inconsistentPlurality"
            starts: 37
            ends: 86
        
    run
        description: "multiple arguments where the middle has inconsistent plurality"
        input: [1, 5, 3, 1]
        throws:
            reason: "inconsistentPlurality"
            starts: 37
            ends: 86
        
    run
        description: "multiple arguments where the middle and last have inconsistent plurality"
        input: [1, 5, 1, 3]
        throws:
            reason: "inconsistentPlurality"
            starts: 37
            ends: 86
        
    run
        description: "multiple arguments where the first and last have inconsistent plurality"
        input: [3, 1, 1, 5]
        throws:
            reason: "inconsistentPlurality"
            starts: 37
            ends: 86