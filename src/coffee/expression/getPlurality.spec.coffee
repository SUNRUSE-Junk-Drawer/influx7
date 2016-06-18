describe "expression", -> describe "getPlurality", ->
    rewire = require "rewire"
    describe "imports", ->
        getPlurality = rewire "./getPlurality"
        it "functionPluralities", -> (expect getPlurality.__get__ "functionPluralities").toBe require "./functionPluralities"
        it "itself", -> (expect getPlurality.__get__ "recurse").toBe getPlurality
    describe "on calling", ->
        getPlurality = rewire "./getPlurality"
        
        functionPluralities = 
            testFunctionA: "concatenate"
            testFunctionB: "map"
            testFunctionC: 
                input: 4
                output: 7
            testFunctionD: "concatenate"
            testFunctionE: "map"
            testFunctionF: 
                input: 9
                output: 12
    
        run = (config) -> describe config.description, ->
            inputCopy = functionPluralitiesCopy = undefined
            beforeEach ->
                inputCopy = JSON.parse JSON.stringify config.input
                getPlurality.__set__ "functionPluralities", functionPluralitiesCopy = JSON.parse JSON.stringify functionPluralities
                getPlurality.__set__ "recurse", (expression) ->
                    (expect config.recursesTo[expression]).not.toBeUndefined()
                    config.recursesTo[expression]
                
            if config.throws
                it "throws the expected exception", -> (expect -> getPlurality inputCopy).toThrow config.throws
            else
                it "returns the expected value", -> (expect getPlurality inputCopy).toEqual config.output
            
            beforeEach ->
                try
                    getPlurality inputCopy
            it "does not modify the function pluralities", -> (expect functionPluralitiesCopy).toEqual functionPluralities
            it "does not modify the input", -> (expect inputCopy).toEqual config.input

        run
            description: "truthy primitive"
            recursesTo: {}
            input:
                primitive: "test primitive"
                value: "test value"
                starts: 37
                ends: 86
            output: 1
            
        run
            description: "falsy primitive"
            recursesTo: {}
            input:
                primitive: "test primitive"
                value: false
                starts: 37
                ends: 86
            output: 1
            
        describe "function call", ->
            describe "map plurality", ->
                run
                    description: "one argument with a plurality of one"
                    recursesTo:
                        testArgumentA: 1
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA"]
                        starts: 37
                        ends: 86
                    output: 1
                    
                run
                    description: "one argument with a plurality of greater than one"
                    recursesTo:
                        testArgumentA: 5
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA"]
                        starts: 37
                        ends: 86
                    output: 5
                    
                run
                    description: "multiple arguments where all have a plurality of one"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 1
                    
                run
                    description: "multiple arguments where all have all but the first have a plurality of one"
                    recursesTo:
                        testArgumentA: 5
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 5
                    
                run
                    description: "multiple arguments where all have all but the middle has a plurality of one"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 5
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 5
                    
                run
                    description: "multiple arguments where all have all but the last have a plurality of one"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 5
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 5
                    
                run
                    description: "multiple arguments where all have all but the first have a plurality other than one"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 5
                        testArgumentC: 5
                        testArgumentD: 5
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 5
                    
                run
                    description: "multiple arguments where all have all but the middle have a plurality other than one"
                    recursesTo:
                        testArgumentA: 5
                        testArgumentB: 1
                        testArgumentC: 5
                        testArgumentD: 5
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 5
                    
                run
                    description: "multiple arguments where all have all but the last have a plurality other than one"
                    recursesTo:
                        testArgumentA: 5
                        testArgumentB: 5
                        testArgumentC: 5
                        testArgumentD: 1
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 5
                    
                run
                    description: "multiple arguments where the first has an inconsistent plurality"
                    recursesTo:
                        testArgumentA: 5
                        testArgumentB: 3
                        testArgumentC: 3
                        testArgumentD: 3
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "inconsistentPlurality"
                        starts: 37
                        ends: 86
                    
                run
                    description: "multiple arguments where the middle has an inconsistent plurality"
                    recursesTo:
                        testArgumentA: 3
                        testArgumentB: 5
                        testArgumentC: 3
                        testArgumentD: 3
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "inconsistentPlurality"
                        starts: 37
                        ends: 86
                    
                run
                    description: "multiple arguments where the last has an inconsistent plurality"
                    recursesTo:
                        testArgumentA: 3
                        testArgumentB: 3
                        testArgumentC: 3
                        testArgumentD: 5
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "inconsistentPlurality"
                        starts: 37
                        ends: 86
                    
                run
                    description: "multiple arguments where the first and middle have inconsistent plurality"
                    recursesTo:
                        testArgumentA: 3
                        testArgumentB: 5
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "inconsistentPlurality"
                        starts: 37
                        ends: 86
                    
                run
                    description: "multiple arguments where the middle has inconsistent plurality"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 5
                        testArgumentC: 3
                        testArgumentD: 1
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "inconsistentPlurality"
                        starts: 37
                        ends: 86
                    
                run
                    description: "multiple arguments where the middle and last have inconsistent plurality"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 5
                        testArgumentC: 1
                        testArgumentD: 3
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "inconsistentPlurality"
                        starts: 37
                        ends: 86
                    
                run
                    description: "multiple arguments where the first and last have inconsistent plurality"
                    recursesTo:
                        testArgumentA: 3
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 5
                    input:
                        call: "testFunctionB"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "inconsistentPlurality"
                        starts: 37
                        ends: 86
                        
            describe "concatenate plurality", ->
                run
                    description: "one argument with a plurality of one"
                    recursesTo:
                        testArgumentA: 1
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA"]
                        starts: 37
                        ends: 86
                    output: 1
                    
                run
                    description: "one argument with a plurality of greater than one"
                    recursesTo:
                        testArgumentA: 5
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA"]
                        starts: 37
                        ends: 86
                    output: 5
                    
                run
                    description: "multiple arguments where all have a plurality of one"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 4
                    
                run
                    description: "multiple arguments where all have all but the first have a plurality of one"
                    recursesTo:
                        testArgumentA: 5
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 8
                    
                run
                    description: "multiple arguments where all have all but the middle has a plurality of one"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 5
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 8
                    
                run
                    description: "multiple arguments where all have all but the last have a plurality of one"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 5
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 8
                    
                run
                    description: "multiple arguments where all have all but the first have a plurality other than one"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 5
                        testArgumentC: 5
                        testArgumentD: 5
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 16
                    
                run
                    description: "multiple arguments where all have all but the middle have a plurality other than one"
                    recursesTo:
                        testArgumentA: 5
                        testArgumentB: 1
                        testArgumentC: 5
                        testArgumentD: 5
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 16
                    
                run
                    description: "multiple arguments where all have all but the last have a plurality other than one"
                    recursesTo:
                        testArgumentA: 5
                        testArgumentB: 5
                        testArgumentC: 5
                        testArgumentD: 1
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 16
                    
                run
                    description: "multiple arguments where the first has an inconsistent plurality"
                    recursesTo:
                        testArgumentA: 5
                        testArgumentB: 3
                        testArgumentC: 3
                        testArgumentD: 3
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 14
                    
                run
                    description: "multiple arguments where the middle has an inconsistent plurality"
                    recursesTo:
                        testArgumentA: 3
                        testArgumentB: 5
                        testArgumentC: 3
                        testArgumentD: 3
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 14
                    
                run
                    description: "multiple arguments where the last has an inconsistent plurality"
                    recursesTo:
                        testArgumentA: 3
                        testArgumentB: 3
                        testArgumentC: 3
                        testArgumentD: 5
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 14
                    
                run
                    description: "multiple arguments where the first and middle have inconsistent plurality"
                    recursesTo:
                        testArgumentA: 3
                        testArgumentB: 5
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 10
                    
                run
                    description: "multiple arguments where the middle has inconsistent plurality"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 5
                        testArgumentC: 3
                        testArgumentD: 1
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 10
                    
                run
                    description: "multiple arguments where the middle and last have inconsistent plurality"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 5
                        testArgumentC: 1
                        testArgumentD: 3
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 10
                    
                run
                    description: "multiple arguments where the first and last have inconsistent plurality"
                    recursesTo:
                        testArgumentA: 3
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 5
                    input:
                        call: "testFunctionD"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 10
            describe "custom plurality", ->
                run
                    description: "one argument with a plurality of one"
                    recursesTo:
                        testArgumentA: 1
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA"]
                        starts: 37
                        ends: 86
                    output: 12
                    
                run
                    description: "one argument with a valid plurality of greater than one"
                    recursesTo:
                        testArgumentA: 9
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA"]
                        starts: 37
                        ends: 86
                    output: 12
                    
                run
                    description: "multiple arguments with a plurality of one"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 12
                    
                run
                    description: "multiple arguments with a valid plurality"
                    recursesTo:
                        testArgumentA: 9
                        testArgumentB: 9
                        testArgumentC: 9
                        testArgumentD: 9
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 12
                    
                run
                    description: "multiple arguments where all have a plurality of one except the first which is valid"
                    recursesTo:
                        testArgumentA: 9
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 12
                    
                run
                    description: "multiple arguments where all have a plurality of one except the middle which is valid"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 9
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 12
                    
                run
                    description: "multiple arguments where all have a plurality of one except the last which is valid"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 9
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    output: 12
                    
                run
                    description: "multiple arguments where all have a plurality of one except the first which is invalid"
                    recursesTo:
                        testArgumentA: 3
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "invalidPlurality"
                        starts: 37
                        ends: 86
                    
                run
                    description: "multiple arguments where all have a plurality of one except the middle which is invalid"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 3
                        testArgumentC: 1
                        testArgumentD: 1
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "invalidPlurality"
                        starts: 37
                        ends: 86
                    
                run
                    description: "multiple arguments where all have a plurality of one except the last which is invalid"
                    recursesTo:
                        testArgumentA: 1
                        testArgumentB: 1
                        testArgumentC: 1
                        testArgumentD: 3
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "invalidPlurality"
                        starts: 37
                        ends: 86
                        
                run
                    description: "multiple arguments where all have a valid plurality except the first which is invalid"
                    recursesTo:
                        testArgumentA: 3
                        testArgumentB: 9
                        testArgumentC: 9
                        testArgumentD: 9
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "invalidPlurality"
                        starts: 37
                        ends: 86
                    
                run
                    description: "multiple arguments where all have a valid plurality except the middle which is invalid"
                    recursesTo:
                        testArgumentA: 9
                        testArgumentB: 3
                        testArgumentC: 9
                        testArgumentD: 9
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "invalidPlurality"
                        starts: 37
                        ends: 86
                    
                run
                    description: "multiple arguments where all have a valid plurality except the last which is invalid"
                    recursesTo:
                        testArgumentA: 9
                        testArgumentB: 9
                        testArgumentC: 9
                        testArgumentD: 3
                    input:
                        call: "testFunctionF"
                        with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                        starts: 37
                        ends: 86
                    throws:
                        reason: "invalidPlurality"
                        starts: 37
                        ends: 86