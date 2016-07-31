describe "expression", -> describe "unroll", -> describe "functions", ->
    rewire = require "rewire"

    describe "standard", ->
        expressionUnrollFunctions = rewire "./functions"

        map = (name) -> describe name, ->
            it "uses \"map\" unrolling", -> (expect expressionUnrollFunctions[name]).toBe require "./map"
            
        map "addInteger"
        map "subtractInteger"
        map "multiplyInteger"
        map "negateInteger"
        
        map "equalInteger"
        map "notEqualInteger"
        map "greaterThanInteger"
        map "greaterThanOrEqualInteger"
        map "lessThanInteger"
        map "lessThanOrEqualInteger"
            
        map "addFloat"
        map "subtractFloat"
        map "multiplyFloat"
        map "divideFloat"
        map "negateFloat"
        
        map "equalFloat"
        map "notEqualFloat"
        map "greaterThanFloat"
        map "greaterThanOrEqualFloat"
        map "lessThanFloat"
        map "lessThanOrEqualFloat"
        
        map "equalBoolean"
        map "notEqualBoolean"
        map "notBoolean"
        map "andBoolean"
        map "orBoolean"
        
        concatenate = (name) -> describe name, ->
            it "uses \"concatenate\" unrolling", -> (expect expressionUnrollFunctions[name]).toBe require "./concatenate"

        concatenate "concatenateFloat"
        concatenate "concatenateInteger"
        concatenate "concatenateBoolean"
    
    describe "custom", ->
        describe "imports", ->
            expressionUnrollFunctions = rewire "./functions"
            it "expressionUnroll", -> (expect expressionUnrollFunctions.__get__ "expressionUnroll").toBe require "./../unroll"
            it "expressionGetPlurality", -> (expect expressionUnrollFunctions.__get__ "expressionGetPlurality").toBe require "./../getPlurality"
        describe "on calling", ->
            expressionUnrollFunctions = rewire "./functions"
            run = (config) -> describe config.func, -> describe config.description, ->
                result = inputCopy = undefined
                beforeEach ->
                    inputCopy = JSON.parse JSON.stringify config.input
                    expressionUnrollFunctions.__set__ "expressionUnroll", (expression, item) ->
                        if config.recursesTo
                            for option in config.recursesTo
                                if option.expression isnt expression then continue
                                if option.item isnt item then continue
                                return option.output
                        fail "unexpected call to expressionUnroll with #{expression}, #{item}"
                    expressionUnrollFunctions.__set__ "expressionGetPlurality", (expression) ->
                        if config.getsPluralityOf
                            match = config.getsPluralityOf[expression]
                            if match then return match
                        fail "unexpected call to expressionGetPlurality with #{expression}"
                    result = expressionUnrollFunctions[config.func] inputCopy, config.item
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
                it "returns the expected output", -> (expect result).toEqual config.output
                
            run
                func: "anyBoolean"
                description: "singular"
                input:
                    call: "anyBoolean"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 1
                recursesTo: [
                    expression: "test argument expression"
                    item: 0
                    output: "test recursed argument expression"
                ]
                output: "test recursed argument expression"
                
            run
                func: "anyBoolean"
                description: "2D"
                input:
                    call: "anyBoolean"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 2
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                ]
                output:
                    call: "orBoolean"
                    starts: 35
                    ends: 67
                    with: [
                        "test recursed argument expression a"
                        "test recursed argument expression b"
                    ]
                
            run
                func: "anyBoolean"
                description: "4D"
                input:
                    call: "anyBoolean"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 4
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                    ,
                        expression: "test argument expression"
                        item: 2
                        output: "test recursed argument expression c"
                    ,
                        expression: "test argument expression"
                        item: 3
                        output: "test recursed argument expression d"
                ]
                output:
                    call: "orBoolean"
                    starts: 35
                    ends: 67
                    with: [
                            "test recursed argument expression a"
                            call: "orBoolean"
                            starts: 35
                            ends: 67
                            with: [
                                "test recursed argument expression b"
                                call: "orBoolean"
                                starts: 35
                                ends: 67
                                with: [
                                    "test recursed argument expression c"
                                    "test recursed argument expression d"
                                ]
                            ]
                    ]
                    
            run
                func: "allBoolean"
                description: "singular"
                input:
                    call: "allBoolean"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 1
                recursesTo: [
                    expression: "test argument expression"
                    item: 0
                    output: "test recursed argument expression"
                ]
                output: "test recursed argument expression"
                
            run
                func: "allBoolean"
                description: "2D"
                input:
                    call: "allBoolean"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 2
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                ]
                output:
                    call: "andBoolean"
                    starts: 35
                    ends: 67
                    with: [
                        "test recursed argument expression a"
                        "test recursed argument expression b"
                    ]
                
            run
                func: "allBoolean"
                description: "4D"
                input:
                    call: "allBoolean"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 4
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                    ,
                        expression: "test argument expression"
                        item: 2
                        output: "test recursed argument expression c"
                    ,
                        expression: "test argument expression"
                        item: 3
                        output: "test recursed argument expression d"
                ]
                output:
                    call: "andBoolean"
                    starts: 35
                    ends: 67
                    with: [
                            "test recursed argument expression a"
                            call: "andBoolean"
                            starts: 35
                            ends: 67
                            with: [
                                "test recursed argument expression b"
                                call: "andBoolean"
                                starts: 35
                                ends: 67
                                with: [
                                    "test recursed argument expression c"
                                    "test recursed argument expression d"
                                ]
                            ]
                    ]
                    
            run
                func: "sumInteger"
                description: "singular"
                input:
                    call: "sumInteger"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 1
                recursesTo: [
                    expression: "test argument expression"
                    item: 0
                    output: "test recursed argument expression"
                ]
                output: "test recursed argument expression"
                
            run
                func: "sumInteger"
                description: "2D"
                input:
                    call: "sumInteger"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 2
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                ]
                output:
                    call: "addInteger"
                    starts: 35
                    ends: 67
                    with: [
                        "test recursed argument expression a"
                        "test recursed argument expression b"
                    ]
                
            run
                func: "sumInteger"
                description: "4D"
                input:
                    call: "sumInteger"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 4
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                    ,
                        expression: "test argument expression"
                        item: 2
                        output: "test recursed argument expression c"
                    ,
                        expression: "test argument expression"
                        item: 3
                        output: "test recursed argument expression d"
                ]
                output:
                    call: "addInteger"
                    starts: 35
                    ends: 67
                    with: [
                            "test recursed argument expression a"
                            call: "addInteger"
                            starts: 35
                            ends: 67
                            with: [
                                "test recursed argument expression b"
                                call: "addInteger"
                                starts: 35
                                ends: 67
                                with: [
                                    "test recursed argument expression c"
                                    "test recursed argument expression d"
                                ]
                            ]
                    ]
                    
            run
                func: "sumFloat"
                description: "singular"
                input:
                    call: "sumFloat"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 1
                recursesTo: [
                    expression: "test argument expression"
                    item: 0
                    output: "test recursed argument expression"
                ]
                output: "test recursed argument expression"
                
            run
                func: "sumFloat"
                description: "2D"
                input:
                    call: "sumFloat"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 2
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                ]
                output:
                    call: "addFloat"
                    starts: 35
                    ends: 67
                    with: [
                        "test recursed argument expression a"
                        "test recursed argument expression b"
                    ]
                
            run
                func: "sumFloat"
                description: "4D"
                input:
                    call: "sumFloat"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 4
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                    ,
                        expression: "test argument expression"
                        item: 2
                        output: "test recursed argument expression c"
                    ,
                        expression: "test argument expression"
                        item: 3
                        output: "test recursed argument expression d"
                ]
                output:
                    call: "addFloat"
                    starts: 35
                    ends: 67
                    with: [
                            "test recursed argument expression a"
                            call: "addFloat"
                            starts: 35
                            ends: 67
                            with: [
                                "test recursed argument expression b"
                                call: "addFloat"
                                starts: 35
                                ends: 67
                                with: [
                                    "test recursed argument expression c"
                                    "test recursed argument expression d"
                                ]
                            ]
                    ]
                    
            run
                func: "productInteger"
                description: "singular"
                input:
                    call: "productInteger"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 1
                recursesTo: [
                    expression: "test argument expression"
                    item: 0
                    output: "test recursed argument expression"
                ]
                output: "test recursed argument expression"
                
            run
                func: "productInteger"
                description: "2D"
                input:
                    call: "productInteger"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 2
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                ]
                output:
                    call: "multiplyInteger"
                    starts: 35
                    ends: 67
                    with: [
                        "test recursed argument expression a"
                        "test recursed argument expression b"
                    ]
                
            run
                func: "productInteger"
                description: "4D"
                input:
                    call: "productInteger"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 4
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                    ,
                        expression: "test argument expression"
                        item: 2
                        output: "test recursed argument expression c"
                    ,
                        expression: "test argument expression"
                        item: 3
                        output: "test recursed argument expression d"
                ]
                output:
                    call: "multiplyInteger"
                    starts: 35
                    ends: 67
                    with: [
                            "test recursed argument expression a"
                            call: "multiplyInteger"
                            starts: 35
                            ends: 67
                            with: [
                                "test recursed argument expression b"
                                call: "multiplyInteger"
                                starts: 35
                                ends: 67
                                with: [
                                    "test recursed argument expression c"
                                    "test recursed argument expression d"
                                ]
                            ]
                    ]
                    
            run
                func: "productFloat"
                description: "singular"
                input:
                    call: "productFloat"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 1
                recursesTo: [
                    expression: "test argument expression"
                    item: 0
                    output: "test recursed argument expression"
                ]
                output: "test recursed argument expression"
                
            run
                func: "productFloat"
                description: "2D"
                input:
                    call: "productFloat"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 2
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                ]
                output:
                    call: "multiplyFloat"
                    starts: 35
                    ends: 67
                    with: [
                        "test recursed argument expression a"
                        "test recursed argument expression b"
                    ]
                
            run
                func: "productFloat"
                description: "4D"
                input:
                    call: "productFloat"
                    with: ["test argument expression"]
                    starts: 35
                    ends: 67
                item: 0
                getsPluralityOf:
                    "test argument expression": 4
                recursesTo: [
                        expression: "test argument expression"
                        item: 0
                        output: "test recursed argument expression a"
                    ,
                        expression: "test argument expression"
                        item: 1
                        output: "test recursed argument expression b"
                    ,
                        expression: "test argument expression"
                        item: 2
                        output: "test recursed argument expression c"
                    ,
                        expression: "test argument expression"
                        item: 3
                        output: "test recursed argument expression d"
                ]
                output:
                    call: "multiplyFloat"
                    starts: 35
                    ends: 67
                    with: [
                            "test recursed argument expression a"
                            call: "multiplyFloat"
                            starts: 35
                            ends: 67
                            with: [
                                "test recursed argument expression b"
                                call: "multiplyFloat"
                                starts: 35
                                ends: 67
                                with: [
                                    "test recursed argument expression c"
                                    "test recursed argument expression d"
                                ]
                            ]
                    ]
        
    it "maps every typed function", ->
        expressionUnrollFunctions = rewire "./functions"
    
        for untypedFunction, typedFunctions of require "./../functionParameters"
            for typedFunction of typedFunctions
                (expect expressionUnrollFunctions[typedFunction]).toEqual (jasmine.any Function), "#{typedFunction} is unmapped"