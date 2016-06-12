describe "expression", -> describe "typeCheck", ->
    rewire = require "rewire"
    
    describe "imports", ->
        expressionTypeCheck = rewire "./typeCheck"
        it "expressionFunctionParameters", -> (expect expressionTypeCheck.__get__ "expressionFunctionParameters").toBe require "./functionParameters"
        it "expressionGetReturnType", -> (expect expressionTypeCheck.__get__ "expressionGetReturnType").toBe require "./getReturnType"
        it "itself", -> (expect expressionTypeCheck.__get__ "recurse").toBe expressionTypeCheck
    describe "unit", ->
        run = (config) ->
            expressionTypeCheck = rewire "./typeCheck"
                
            describe config.description, ->
                expressionFunctionParametersCopy = inputCopy = undefined
                beforeEach ->
                    inputCopy = JSON.parse JSON.stringify config.input
                    expressionTypeCheck.__set__ "recurse", (expr) -> 
                        (expect config.recursesTo[expr]).not.toBeUndefined "unexpected recurse of #{expr}"
                        config.recursesTo[expr]
                    expressionTypeCheck.__set__ "expressionGetReturnType", (expr) ->
                        (expect config.getsReturnTypeOf[expr]).not.toBeUndefined "unexpected expressionGetReturnType of #{expr}"
                        config.getsReturnTypeOf[expr]
                    expressionFunctionParametersCopy = JSON.parse JSON.stringify config.expressionFunctionParameters
                    expressionTypeCheck.__set__ "expressionFunctionParameters", expressionFunctionParametersCopy
                if config.throws
                    it "throws the expected exception", -> (expect -> expressionTypeCheck inputCopy).toThrow config.throws
                else
                    it "returns the expected result", -> (expect expressionTypeCheck inputCopy).toEqual config.output
                beforeEach ->
                    try
                        expressionTypeCheck inputCopy
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
                it "does not modify expressionFunctionParameters", -> (expect expressionFunctionParametersCopy).toEqual config.expressionFunctionParameters
        run
            description: "truthy primitive"
            input:
                primitive: "test primitive"
                value: "test value"
            output:
                primitive: "test primitive"
                value: "test value"
            expressionFunctionParameters:
                testUnreferencedFunction: ["testArgumentTypeC", "testArgumentTypeB"]
        run
            description: "falsy primitive"
            input:
                primitive: "test primitive"
                value: false
            output:
                primitive: "test primitive"
                value: false
            expressionFunctionParameters:
                testUnreferencedFunction: ["testArgumentTypeC", "testArgumentTypeB"]
        run
            description: "function call where no overloads match on parameter count"
            input:
                call: "testUntypedFunctionB"
                with: ["testUntypeCheckedArgumentA", "testUntypeCheckedArgumentB", "testUntypeCheckedArgumentC", "testUntypeCheckedArgumentD"]
                starts: 50
                ends: 65
            recursesTo:
                testUntypeCheckedArgumentA: "testTypeCheckedArgumentA"
                testUntypeCheckedArgumentB: "testTypeCheckedArgumentB"
                testUntypeCheckedArgumentC: "testTypeCheckedArgumentC"
                testUntypeCheckedArgumentD: "testTypeCheckedArgumentD"
            getsReturnTypeOf:
                testTypeCheckedArgumentA: "testArgumentTypeA"
                testTypeCheckedArgumentB: "testArgumentTypeB"
                testTypeCheckedArgumentC: "testArgumentTypeC"
                testTypeCheckedArgumentD: "testArgumentTypeD"
            expressionFunctionParameters:
                testUntypedFunctionA:
                    testTypedFunctionAA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionAB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                testUntypedFunctionB:
                    testTypedFunctionBA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionBB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                testUntypedFunctionC:
                    testTypedFunctionCA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionCB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
            throws:
                reason: "typeCheckFailed"
                starts: 50
                ends: 65
        run
            description: "function call where no overloads from our function match"
            input:
                call: "testUntypedFunctionB"
                with: ["testUntypeCheckedArgumentA", "testUntypeCheckedArgumentB", "testUntypeCheckedArgumentC", "testUntypeCheckedArgumentD"]
                starts: 50
                ends: 65
            recursesTo:
                testUntypeCheckedArgumentA: "testTypeCheckedArgumentA"
                testUntypeCheckedArgumentB: "testTypeCheckedArgumentB"
                testUntypeCheckedArgumentC: "testTypeCheckedArgumentC"
                testUntypeCheckedArgumentD: "testTypeCheckedArgumentD"
            getsReturnTypeOf:
                testTypeCheckedArgumentA: "testArgumentTypeA"
                testTypeCheckedArgumentB: "testArgumentTypeB"
                testTypeCheckedArgumentC: "testArgumentTypeC"
                testTypeCheckedArgumentD: "testArgumentTypeD"
            expressionFunctionParameters:
                testUntypedFunctionA:
                    testTypedFunctionAA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionAB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionAC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                testUntypedFunctionB:
                    testTypedFunctionBA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionBB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                testUntypedFunctionC:
                    testTypedFunctionCA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionCB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionCC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
            throws:
                reason: "typeCheckFailed"
                starts: 50
                ends: 65
        run
            description: "function call where an overload matches on parameter count but the first argument type is wrong"
            input:
                call: "testUntypedFunctionB"
                with: ["testUntypeCheckedArgumentA", "testUntypeCheckedArgumentB", "testUntypeCheckedArgumentC", "testUntypeCheckedArgumentD"]
                starts: 50
                ends: 65
            recursesTo:
                testUntypeCheckedArgumentA: "testTypeCheckedArgumentA"
                testUntypeCheckedArgumentB: "testTypeCheckedArgumentB"
                testUntypeCheckedArgumentC: "testTypeCheckedArgumentC"
                testUntypeCheckedArgumentD: "testTypeCheckedArgumentD"
            getsReturnTypeOf:
                testTypeCheckedArgumentA: "testArgumentTypeA"
                testTypeCheckedArgumentB: "testArgumentTypeB"
                testTypeCheckedArgumentC: "testArgumentTypeC"
                testTypeCheckedArgumentD: "testArgumentTypeD"
            expressionFunctionParameters:
                testUntypedFunctionA:
                    testTypedFunctionAA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionAB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionAC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                testUntypedFunctionB:
                    testTypedFunctionBA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionBB: ["testArgumentTypeE", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                    testTypedFunctionBC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                testUntypedFunctionC:
                    testTypedFunctionCA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionCB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionCC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
            throws:
                reason: "typeCheckFailed"
                starts: 50
                ends: 65
        run
            description: "function call where an overload matches on parameter count but an argument type neither first nor last is wrong"
            input:
                call: "testUntypedFunctionB"
                with: ["testUntypeCheckedArgumentA", "testUntypeCheckedArgumentB", "testUntypeCheckedArgumentC", "testUntypeCheckedArgumentD"]
                starts: 50
                ends: 65
            recursesTo:
                testUntypeCheckedArgumentA: "testTypeCheckedArgumentA"
                testUntypeCheckedArgumentB: "testTypeCheckedArgumentB"
                testUntypeCheckedArgumentC: "testTypeCheckedArgumentC"
                testUntypeCheckedArgumentD: "testTypeCheckedArgumentD"
            getsReturnTypeOf:
                testTypeCheckedArgumentA: "testArgumentTypeA"
                testTypeCheckedArgumentB: "testArgumentTypeB"
                testTypeCheckedArgumentC: "testArgumentTypeC"
                testTypeCheckedArgumentD: "testArgumentTypeD"
            expressionFunctionParameters:
                testUntypedFunctionA:
                    testTypedFunctionAA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionAB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionAC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                testUntypedFunctionB:
                    testTypedFunctionBA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionBB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeE", "testArgumentTypeD"]
                    testTypedFunctionBC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                testUntypedFunctionC:
                    testTypedFunctionCA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionCB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionCC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
            throws:
                reason: "typeCheckFailed"
                starts: 50
                ends: 65
        run
            description: "function call where an overload matches on parameter count but the last argument type is wrong"
            input:
                call: "testUntypedFunctionB"
                with: ["testUntypeCheckedArgumentA", "testUntypeCheckedArgumentB", "testUntypeCheckedArgumentC", "testUntypeCheckedArgumentD"]
                starts: 50
                ends: 65
            recursesTo:
                testUntypeCheckedArgumentA: "testTypeCheckedArgumentA"
                testUntypeCheckedArgumentB: "testTypeCheckedArgumentB"
                testUntypeCheckedArgumentC: "testTypeCheckedArgumentC"
                testUntypeCheckedArgumentD: "testTypeCheckedArgumentD"
            getsReturnTypeOf:
                testTypeCheckedArgumentA: "testArgumentTypeA"
                testTypeCheckedArgumentB: "testArgumentTypeB"
                testTypeCheckedArgumentC: "testArgumentTypeC"
                testTypeCheckedArgumentD: "testArgumentTypeD"
            expressionFunctionParameters:
                testUntypedFunctionA:
                    testTypedFunctionAA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionAB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionAC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                testUntypedFunctionB:
                    testTypedFunctionBA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionBB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeE"]
                    testTypedFunctionBC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                testUntypedFunctionC:
                    testTypedFunctionCA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionCB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionCC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
            throws:
                reason: "typeCheckFailed"
                starts: 50
                ends: 65
        run
            description: "function call where an overload matches on parameter count but the order"
            input:
                call: "testUntypedFunctionB"
                with: ["testUntypeCheckedArgumentA", "testUntypeCheckedArgumentB", "testUntypeCheckedArgumentC", "testUntypeCheckedArgumentD"]
                starts: 50
                ends: 65
            recursesTo:
                testUntypeCheckedArgumentA: "testTypeCheckedArgumentA"
                testUntypeCheckedArgumentB: "testTypeCheckedArgumentB"
                testUntypeCheckedArgumentC: "testTypeCheckedArgumentC"
                testUntypeCheckedArgumentD: "testTypeCheckedArgumentD"
            getsReturnTypeOf:
                testTypeCheckedArgumentA: "testArgumentTypeA"
                testTypeCheckedArgumentB: "testArgumentTypeB"
                testTypeCheckedArgumentC: "testArgumentTypeC"
                testTypeCheckedArgumentD: "testArgumentTypeD"
            expressionFunctionParameters:
                testUntypedFunctionA:
                    testTypedFunctionAA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionAB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionAC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                testUntypedFunctionB:
                    testTypedFunctionBA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionBB: ["testArgumentTypeA", "testArgumentTypeC", "testArgumentTypeB", "testArgumentTypeD"]
                    testTypedFunctionBC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                testUntypedFunctionC:
                    testTypedFunctionCA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionCB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionCC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
            throws:
                reason: "typeCheckFailed"
                starts: 50
                ends: 65
        run
            description: "function call where an overload matches on parameter count and argument types"
            input:
                call: "testUntypedFunctionB"
                with: ["testUntypeCheckedArgumentA", "testUntypeCheckedArgumentB", "testUntypeCheckedArgumentC", "testUntypeCheckedArgumentD"]
                starts: 50
                ends: 65
            recursesTo:
                testUntypeCheckedArgumentA: "testTypeCheckedArgumentA"
                testUntypeCheckedArgumentB: "testTypeCheckedArgumentB"
                testUntypeCheckedArgumentC: "testTypeCheckedArgumentC"
                testUntypeCheckedArgumentD: "testTypeCheckedArgumentD"
            getsReturnTypeOf:
                testTypeCheckedArgumentA: "testArgumentTypeA"
                testTypeCheckedArgumentB: "testArgumentTypeB"
                testTypeCheckedArgumentC: "testArgumentTypeC"
                testTypeCheckedArgumentD: "testArgumentTypeD"
            expressionFunctionParameters:
                testUntypedFunctionA:
                    testTypedFunctionAA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionAB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionAC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                testUntypedFunctionB:
                    testTypedFunctionBA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionBB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                    testTypedFunctionBC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                testUntypedFunctionC:
                    testTypedFunctionCA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionCB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionCC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
            output:
                call: "testTypedFunctionBB"
                with: ["testTypeCheckedArgumentA", "testTypeCheckedArgumentB", "testTypeCheckedArgumentC", "testTypeCheckedArgumentD"]
                starts: 50
                ends: 65
        run
            description: "function call where an overload matches on parameter count and argument types with invalid overloads"
            input:
                call: "testUntypedFunctionB"
                with: ["testUntypeCheckedArgumentA", "testUntypeCheckedArgumentB", "testUntypeCheckedArgumentC", "testUntypeCheckedArgumentD"]
                starts: 50
                ends: 65
            recursesTo:
                testUntypeCheckedArgumentA: "testTypeCheckedArgumentA"
                testUntypeCheckedArgumentB: "testTypeCheckedArgumentB"
                testUntypeCheckedArgumentC: "testTypeCheckedArgumentC"
                testUntypeCheckedArgumentD: "testTypeCheckedArgumentD"
            getsReturnTypeOf:
                testTypeCheckedArgumentA: "testArgumentTypeA"
                testTypeCheckedArgumentB: "testArgumentTypeB"
                testTypeCheckedArgumentC: "testArgumentTypeC"
                testTypeCheckedArgumentD: "testArgumentTypeD"
            expressionFunctionParameters:
                testUntypedFunctionA:
                    testTypedFunctionAA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionAB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionAC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                testUntypedFunctionB:
                    testTypedFunctionBA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionBB: ["testArgumentTypeE", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                    testTypedFunctionBC: ["testArgumentTypeA", "testArgumentTypeE", "testArgumentTypeC", "testArgumentTypeD"]
                    testTypedFunctionBD: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeE"]
                    testTypedFunctionBE: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
                    testTypedFunctionBF: ["testArgumentTypeA", "testArgumentTypeC", "testArgumentTypeB", "testArgumentTypeD"]
                    testTypedFunctionBG: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                testUntypedFunctionC:
                    testTypedFunctionCA: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC"]
                    testTypedFunctionCB: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD", "testArgumentTypeE"]
                    testTypedFunctionCC: ["testArgumentTypeA", "testArgumentTypeB", "testArgumentTypeC", "testArgumentTypeD"]
            output:
                call: "testTypedFunctionBE"
                with: ["testTypeCheckedArgumentA", "testTypeCheckedArgumentB", "testTypeCheckedArgumentC", "testTypeCheckedArgumentD"]
                starts: 50
                ends: 65
    describe "integration", ->
        expressionTypeCheck = rewire "./typeCheck"
        expressionParse = rewire "./parse"
        tokenize = rewire "./../tokenize"
        
        run = (config) ->
            describe config.description, ->
                if config.throws
                    it "throws the expected exception", -> (expect -> expressionTypeCheck expressionParse tokenize config.input).toThrow config.throws
                else
                    it "returns the expected expression tree", -> (expect expressionTypeCheck expressionParse tokenize config.input).toEqual config.output

        run
            description: "completely incorrect types"
            input: "false and false > true or true"
            throws:
                reason: "typeCheckFailed"
                starts: 16
                ends: 16

        run
            description: "first type incorrect"
            input: "false and 3 > true or true"
            throws:
                reason: "typeCheckFailed"
                starts: 12
                ends: 12
                
        run
            description: "last type incorrect"
            input: "false and false > 3 or true"
            throws:
                reason: "typeCheckFailed"
                starts: 16
                ends: 16
                    
        run
            description: "complex scenario"
            input: "false and not 4.7 < 8.4 + -3.1 or -8 * 9 is 2 * 4 + 7 * 8 and false != true"
            output:
                call: "andBoolean"
                starts: 6
                ends: 8
                with: [
                        primitive: "boolean"
                        value: false
                        starts: 0
                        ends: 4
                    ,
                        call: "andBoolean"
                        starts: 58
                        ends: 60
                        with: [
                                call: "notBoolean"
                                starts: 10
                                ends: 12
                                with: [
                                    call: "orBoolean"
                                    starts: 31
                                    ends: 32
                                    with: [
                                            call: "lessThanFloat"
                                            starts: 18
                                            ends: 18
                                            with: [
                                                    primitive: "float"
                                                    value: 4.7
                                                    starts: 14
                                                    ends: 16
                                                ,
                                                    call: "addFloat"
                                                    starts: 24
                                                    ends: 24
                                                    with: [
                                                            primitive: "float"
                                                            value: 8.4
                                                            starts: 20
                                                            ends: 22
                                                        ,
                                                            call: "negateFloat"
                                                            starts: 26
                                                            ends: 26
                                                            with: [
                                                                primitive: "float"
                                                                value: 3.1
                                                                starts: 27
                                                                ends: 29
                                                            ]
                                                    ]
                                            ]
                                        ,
                                            call: "equalInteger"
                                            starts: 41
                                            ends: 42
                                            with: [
                                                    call: "multiplyInteger"
                                                    starts: 37
                                                    ends: 37
                                                    with: [
                                                            call: "negateInteger"
                                                            starts: 34
                                                            ends: 34
                                                            with: [
                                                                primitive: "integer"
                                                                value: 8
                                                                starts: 35
                                                                ends: 35
                                                            ]
                                                        ,
                                                            primitive: "integer"
                                                            value: 9
                                                            starts: 39
                                                            ends: 39
                                                    ]
                                                ,
                                                    call: "addInteger"
                                                    starts: 50
                                                    ends: 50
                                                    with: [
                                                            call: "multiplyInteger"
                                                            starts: 46
                                                            ends: 46
                                                            with: [
                                                                    primitive: "integer"
                                                                    value: 2
                                                                    starts: 44
                                                                    ends: 44
                                                                ,
                                                                    primitive: "integer"
                                                                    value: 4
                                                                    starts: 48
                                                                    ends: 48
                                                            ]
                                                        ,
                                                            call: "multiplyInteger"
                                                            starts: 54
                                                            ends: 54
                                                            with: [
                                                                    primitive: "integer"
                                                                    value: 7
                                                                    starts: 52
                                                                    ends: 52
                                                                ,
                                                                    primitive: "integer"
                                                                    value: 8
                                                                    starts: 56
                                                                    ends: 56
                                                            ]
                                                    ]
                                            ]
                                    ]
                                ]
                            ,
                                call: "notEqualBoolean"
                                starts: 68
                                ends: 69
                                with: [
                                        primitive: "boolean"
                                        value: false
                                        starts: 62
                                        ends: 66
                                    ,
                                        primitive: "boolean"
                                        value: true
                                        starts: 71
                                        ends: 74
                                ]
                        ]
                ]