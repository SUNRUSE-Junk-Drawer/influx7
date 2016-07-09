describe "expression", -> describe "unroll", -> describe "concatenate", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionUnrollConcatenate = rewire "./concatenate"
        it "expressionGetPlurality", -> (expect expressionUnrollConcatenate.__get__ "expressionGetPlurality").toBe require "./../getPlurality"
        it "expressionUnroll", -> (expect expressionUnrollConcatenate.__get__ "expressionUnroll").toBe require "./../unroll"
    describe "on calling", ->
        expressionUnrollConcatenate = rewire "./concatenate"
        run = (config) -> describe config.description, ->
            result = expressionCopy = undefined
            beforeEach ->
                expressionUnrollConcatenate.__set__ "expressionGetPlurality", (expression) ->
                    mapping = config.getsPluralityOf[expression]
                    if mapping is undefined
                        fail "unexpected call to expressionGetPlurality for #{expression}"
                    else
                        mapping
                expressionUnrollConcatenate.__set__ "expressionUnroll", (expression, item) ->
                    mapping = config.unrolls[expression]
                    if mapping is undefined
                        fail "unexpected call to expressionUnroll for expression #{expression}"
                    else
                        unrolled = mapping[item]
                        if unrolled is undefined
                            fail "unexpected call to expressionUnroll for item #{item}"
                        else
                            unrolled
                expressionCopy = JSON.parse JSON.stringify config.expression
                result = expressionUnrollConcatenate expressionCopy, config.item
            it "does not modify the input", -> (expect expressionCopy).toEqual config.expression
            it "returns the expected output", -> (expect result).toEqual config.output
        
        run
            description: "first item in first argument"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB"]
                starts: "test starts"
                ends: "test ends"
            item: 0
            getsPluralityOf:
                testArgumentA: 4
                testArgumentB: 5
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgument"
            output: "testUnrolledArgument"
            
        run
            description: "middle item in first argument"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB"]
                starts: "test starts"
                ends: "test ends"
            item: 2
            getsPluralityOf:
                testArgumentA: 4
                testArgumentB: 5
            unrolls:
                testArgumentA:
                    "2": "testUnrolledArgument"
            output: "testUnrolledArgument"
            
        run
            description: "last item in first argument"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB"]
                starts: "test starts"
                ends: "test ends"
            item: 3
            getsPluralityOf:
                testArgumentA: 4
                testArgumentB: 5
            unrolls:
                testArgumentA:
                    "3": "testUnrolledArgument"
            output: "testUnrolledArgument"
            
        run
            description: "first item in second argument"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB"]
                starts: "test starts"
                ends: "test ends"
            item: 4
            getsPluralityOf:
                testArgumentA: 4
                testArgumentB: 5
            unrolls:
                testArgumentB:
                    "0": "testUnrolledArgument"
            output: "testUnrolledArgument"
            
        run
            description: "middle item in second argument"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB"]
                starts: "test starts"
                ends: "test ends"
            item: 6
            getsPluralityOf:
                testArgumentA: 4
                testArgumentB: 5
            unrolls:
                testArgumentB:
                    "2": "testUnrolledArgument"
            output: "testUnrolledArgument"
            
        run
            description: "last item in second argument"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB"]
                starts: "test starts"
                ends: "test ends"
            item: 8
            getsPluralityOf:
                testArgumentA: 4
                testArgumentB: 5
            unrolls:
                testArgumentB:
                    "4": "testUnrolledArgument"
            output: "testUnrolledArgument"