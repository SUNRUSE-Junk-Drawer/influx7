describe "expression", -> describe "unroll", -> describe "map", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionUnrollMap = rewire "./map"
        it "expressionGetPlurality", -> (expect expressionUnrollMap.__get__ "expressionGetPlurality").toBe require "./../getPlurality"
        it "expressionUnroll", -> (expect expressionUnrollMap.__get__ "expressionUnroll").toBe require "./../unroll"
    describe "on calling", ->
        expressionUnrollMap = rewire "./map"
        run = (config) -> describe config.description, ->
            result = expressionCopy = undefined
            beforeEach ->
                expressionUnrollMap.__set__ "expressionGetPlurality", (expression) ->
                    mapping = config.getsPluralityOf[expression]
                    if mapping is undefined
                        fail "unexpected call to expressionGetPlurality for #{expression}"
                    else
                        mapping
                expressionUnrollMap.__set__ "expressionUnroll", (expression, item) ->
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
                result = expressionUnrollMap expressionCopy, config.item
            it "does not modify the input", -> (expect expressionCopy).toEqual config.expression
            it "returns the expected output", -> (expect result).toEqual config.output
        
        run
            description: "all have one item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 0
            getsPluralityOf:
                testArgumentA: 1
                testArgumentB: 1
                testArgumentC: 1
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends"
        
        run
            description: "all have multiple items, first item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 0
            getsPluralityOf:
                testArgumentA: 7
                testArgumentB: 7
                testArgumentC: 7
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends"
                
        run
            description: "all have multiple items, subsequent item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 4
            getsPluralityOf:
                testArgumentA: 7
                testArgumentB: 7
                testArgumentC: 7
            unrolls:
                testArgumentA:
                    "4": "testUnrolledArgumentA"
                testArgumentB:
                    "4": "testUnrolledArgumentB"
                testArgumentC:
                    "4": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends"                
               
        run
            description: "only the first has multiple items, first item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 0
            getsPluralityOf:
                testArgumentA: 7
                testArgumentB: 1
                testArgumentC: 1
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends"
                
        run
            description: "only the first has multiple items, subsequent item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 4
            getsPluralityOf:
                testArgumentA: 7
                testArgumentB: 1
                testArgumentC: 1
            unrolls:
                testArgumentA:
                    "4": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends"  
               
        run
            description: "only the middle has multiple items, first item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 0
            getsPluralityOf:
                testArgumentA: 1
                testArgumentB: 7
                testArgumentC: 1
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends"
                
        run
            description: "only the middle has multiple items, subsequent item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 4
            getsPluralityOf:
                testArgumentA: 1
                testArgumentB: 7
                testArgumentC: 1
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "4": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends" 
               
        run
            description: "only the last has multiple items, first item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 0
            getsPluralityOf:
                testArgumentA: 1
                testArgumentB: 1
                testArgumentC: 7
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends"
                
        run
            description: "only the last has multiple items, subsequent item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 4
            getsPluralityOf:
                testArgumentA: 1
                testArgumentB: 1
                testArgumentC: 7
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "4": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends" 
                
        run
            description: "only the first has one item, first item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 0
            getsPluralityOf:
                testArgumentA: 1
                testArgumentB: 7
                testArgumentC: 7
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends"
                
        run
            description: "only the first has one item, subsequent item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 4
            getsPluralityOf:
                testArgumentA: 1
                testArgumentB: 7
                testArgumentC: 7
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "4": "testUnrolledArgumentB"
                testArgumentC:
                    "4": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends" 
                
        run
            description: "only the middle has one item, first item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 0
            getsPluralityOf:
                testArgumentA: 7
                testArgumentB: 1
                testArgumentC: 7
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends"
                
        run
            description: "only the middle has one item, subsequent item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 4
            getsPluralityOf:
                testArgumentA: 7
                testArgumentB: 1
                testArgumentC: 7
            unrolls:
                testArgumentA:
                    "4": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "4": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends" 
               
        run
            description: "only the last has one item, first item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 0
            getsPluralityOf:
                testArgumentA: 7
                testArgumentB: 7
                testArgumentC: 1
            unrolls:
                testArgumentA:
                    "0": "testUnrolledArgumentA"
                testArgumentB:
                    "0": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends"
                
        run
            description: "only the last has one item, subsequent item"
            expression:
                call: "test function"
                with: ["testArgumentA", "testArgumentB", "testArgumentC"]
                starts: "test starts"
                ends: "test ends"
            item: 4
            getsPluralityOf:
                testArgumentA: 7
                testArgumentB: 7
                testArgumentC: 1
            unrolls:
                testArgumentA:
                    "4": "testUnrolledArgumentA"
                testArgumentB:
                    "4": "testUnrolledArgumentB"
                testArgumentC:
                    "0": "testUnrolledArgumentC"
            output:
                call: "test function"
                with: ["testUnrolledArgumentA", "testUnrolledArgumentB", "testUnrolledArgumentC"]
                starts: "test starts"
                ends: "test ends" 