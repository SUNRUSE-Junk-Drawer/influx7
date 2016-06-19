describe "expression", -> describe "getPlurality", ->
    rewire = require "rewire"
    describe "imports", ->
        getPlurality = rewire "./getPlurality"
        it "functionPluralities", -> (expect getPlurality.__get__ "functionPluralities").toBe require "./functionPluralities"
        it "itself", -> (expect getPlurality.__get__ "recurse").toBe getPlurality
    describe "on calling", ->
        getPlurality = rewire "./getPlurality"
    
        run = (config) -> describe config.description, ->
            inputCopy = functionPluralitiesCopy = undefined
            beforeEach ->
                inputCopy = JSON.parse JSON.stringify config.input
                functionPluralitiesCopy = {}
                for key, value of config.functionPluralities
                    functionPluralitiesCopy[key] = value
                getPlurality.__set__ "functionPluralities", functionPluralitiesCopy
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
            it "does not modify the function pluralities", -> (expect functionPluralitiesCopy).toEqual config.functionPluralities
            it "does not modify the input", -> (expect inputCopy).toEqual config.input

        run
            description: "truthy primitive"
            recursesTo: {}
            functionPluralities:
                testFunctionA: -> "unexpected call to function plurality a"
                testFunctionB: -> "unexpected call to function plurality b"
                testFunctionC: -> "unexpected call to function plurality c"
            input:
                primitive: "test primitive"
                value: "test value"
                starts: 37
                ends: 86
            output: 1
            
        run
            description: "falsy primitive"
            recursesTo: {}
            functionPluralities:
                testFunctionA: -> "unexpected call to function plurality a"
                testFunctionB: -> "unexpected call to function plurality b"
                testFunctionC: -> "unexpected call to function plurality c"
            input:
                primitive: "test primitive"
                value: false
                starts: 37
                ends: 86
            output: 1
            
        run
            description: "function call"
            recursesTo: 
                testArgumentA: "testArgumentPluralityA"
                testArgumentB: "testArgumentPluralityB"
                testArgumentC: "testArgumentPluralityC"
                testArgumentD: "testArgumentPluralityD"
            functionPluralities:
                testFunctionA: -> "unexpected call to function plurality a"
                testFunctionB: (argumentPluralities, starts, ends) ->
                    (expect argumentPluralities).toEqual ["testArgumentPluralityA", "testArgumentPluralityB", "testArgumentPluralityC", "testArgumentPluralityD"]
                    (expect starts).toEqual 37
                    (expect ends).toEqual 86
                    "testFunctionPlurality"
                testFunctionC: -> "unexpected call to function plurality c"
            input:
                call: "testFunctionB"
                with: ["testArgumentA", "testArgumentB", "testArgumentC", "testArgumentD"]
                starts: 37
                ends: 86
            output: "testFunctionPlurality"