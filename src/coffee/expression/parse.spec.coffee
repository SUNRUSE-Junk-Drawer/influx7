describe "expression", -> describe "parse", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParse = rewire "./parse"
        it "expressionParseBoolean", -> (expect expressionParse.__get__ "expressionParseBoolean").toBe require "./parse/boolean"
        it "expressionParseInteger", -> (expect expressionParse.__get__ "expressionParseInteger").toBe require "./parse/integer"
        it "expressionParseFloat", -> (expect expressionParse.__get__ "expressionParseFloat").toBe require "./parse/float"
        it "expressionParseUnary", -> (expect expressionParse.__get__ "expressionParseUnary").toBe require "./parse/unary"
        it "expressionParseBinary", -> (expect expressionParse.__get__ "expressionParseBinary").toBe require "./parse/binary"
        it "expressionParseParentheses", -> (expect expressionParse.__get__ "expressionParseParentheses").toBe require "./parse/parentheses"
        it "expressionParseOperatorPrecedence", -> (expect expressionParse.__get__ "expressionParseOperatorPrecedence").toBe require "./parse/operatorPrecedence"
        
    describe "unit", ->
        expressionParse = rewire "./parse"
        
        inputCopy = [
                token: "test token a"
                starts: 21
                ends: 45
            ,
                token: "test token b"
                starts: 75
                ends: 121
            ,
                token: "test token c"
                starts: 223
                ends: 241
        ]
            
        operatorPrecedenceCopy = [
                unary: "testLevelAUnary"
                binary: "testLevelABinary"
            ,
                unary: "testLevelBUnary"
                binary: "testLevelBBinary"
            ,
                unary: "testLevelCUnary"
                binary: "testLevelCBinary"
            ,
                unary: "testLevelDUnary"
                binary: "testLevelDBinary"
        ]
        
        run = (config) ->
            describe config.description, ->
                operatorPrecedence = result = input = undefined
                
                beforeEach ->                    
                    operatorPrecedence = JSON.parse JSON.stringify operatorPrecedenceCopy
                    expressionParse.__set__ "expressionParseOperatorPrecedence", operatorPrecedence
                
                    expressionParse.__set__ "expressionParseParentheses", (expr) ->
                        (expect expr).toEqual inputCopy
                        config.parsesParenthesesTo or null
                    expressionParse.__set__ "expressionParseBoolean", (expr) ->
                        (expect expr).toEqual inputCopy
                        config.parsesBooleanTo or null
                    expressionParse.__set__ "expressionParseInteger", (expr) ->
                        (expect expr).toEqual inputCopy
                        config.parsesIntegerTo or null
                    expressionParse.__set__ "expressionParseFloat", (expr) ->
                        (expect expr).toEqual inputCopy
                        config.parsesFloatTo or null
                    expressionParse.__set__ "expressionParseUnary", (expr, operators) ->
                        (expect expr).toEqual inputCopy
                        (expect config.parsesUnaryTo[operators]).not.toBeUndefined()
                        config.parsesUnaryTo[operators]
                    expressionParse.__set__ "expressionParseBinary", (expr, operators) ->
                        (expect expr).toEqual inputCopy
                        (expect config.parsesBinaryTo[operators]).not.toBeUndefined()
                        config.parsesBinaryTo[operators]
                
                    input = JSON.parse JSON.stringify inputCopy
                
                if config.output isnt undefined
                    it "returns the expected result", -> (expect expressionParse inputCopy).toEqual config.output
                else
                    it "throws the expected exception", -> (expect -> expressionParse inputCopy).toThrow config.throws

                beforeEach -> 
                    try
                        expressionParse input
                    catch
                    
                it "does not modify the input", -> (expect input).toEqual inputCopy
                it "does not modify the operator precedence", -> (expect operatorPrecedence).toEqual operatorPrecedenceCopy                
        
        run
            description: "no matches"
            parsesUnaryTo:
                testLevelAUnary: null
                testLevelBUnary: null
                testLevelCUnary: null
                testLevelDUnary: null
            parsesBinaryTo:
                testLevelABinary: null
                testLevelBBinary: null
                testLevelCBinary: null
                testLevelDBinary: null
            throws: 
                reason: "invalidExpression"
                starts: 21
                ends: 241
            
        run
            description: "parentheses"
            parsesUnaryTo:
                testLevelAUnary: null
                testLevelBUnary: null
                testLevelCUnary: null
                testLevelDUnary: null
            parsesBinaryTo:
                testLevelABinary: null
                testLevelBBinary: null
                testLevelCBinary: null
                testLevelDBinary: null
            parsesParenthesesTo: "test parsed parentheses expression"
            output: "test parsed parentheses expression"
            
        describe "literals", ->
            run
                description: "boolean expression"
                parsesUnaryTo:
                    testLevelAUnary: null
                    testLevelBUnary: null
                    testLevelCUnary: null
                    testLevelDUnary: null
                parsesBinaryTo:
                    testLevelABinary: null
                    testLevelBBinary: null
                    testLevelCBinary: null
                    testLevelDBinary: null
                parsesBooleanTo: "test parsed boolean expression"
                output: "test parsed boolean expression"
                
            run
                description: "float expression"
                parsesUnaryTo:
                    testLevelAUnary: null
                    testLevelBUnary: null
                    testLevelCUnary: null
                    testLevelDUnary: null
                parsesBinaryTo:
                    testLevelABinary: null
                    testLevelBBinary: null
                    testLevelCBinary: null
                    testLevelDBinary: null
                parsesFloatTo: "test parsed float expression"
                output: "test parsed float expression"
                
            run
                description: "integer expression"
                parsesUnaryTo:
                    testLevelAUnary: null
                    testLevelBUnary: null
                    testLevelCUnary: null
                    testLevelDUnary: null
                parsesBinaryTo:
                    testLevelABinary: null
                    testLevelBBinary: null
                    testLevelCBinary: null
                    testLevelDBinary: null
                parsesIntegerTo: "test parsed integer expression"
                output: "test parsed integer expression"
        
        describe "operators", ->
            run
                description: "unary expression"
                parsesUnaryTo:
                    testLevelAUnary: null
                    testLevelBUnary: null
                    testLevelCUnary: "test parsed unary expression"
                    testLevelDUnary: null
                parsesBinaryTo:
                    testLevelABinary: null
                    testLevelBBinary: null
                    testLevelCBinary: null
                    testLevelDBinary: null
                output: "test parsed unary expression"

            run
                description: "binary expression"
                parsesUnaryTo:
                    testLevelAUnary: null
                    testLevelBUnary: null
                    testLevelCUnary: null
                    testLevelDUnary: null
                parsesBinaryTo:
                    testLevelABinary: null
                    testLevelBBinary: null
                    testLevelCBinary: "test parsed binary expression"
                    testLevelDBinary: null
                output: "test parsed binary expression"

            run
                description: "unary expression with precedence over unary"
                parsesUnaryTo:
                    testLevelAUnary: null
                    testLevelBUnary: "test parsed upper expression"
                    testLevelCUnary: "test parsed lower expression"
                    testLevelDUnary: null
                parsesBinaryTo:
                    testLevelABinary: null
                    testLevelBBinary: null
                    testLevelCBinary: null
                    testLevelDBinary: null
                output: "test parsed upper expression"
            
            run
                description: "binary expression with precedence over unary"
                parsesUnaryTo:
                    testLevelAUnary: null
                    testLevelBUnary: null
                    testLevelCUnary: "test parsed lower expression"
                    testLevelDUnary: null
                parsesBinaryTo:
                    testLevelABinary: null
                    testLevelBBinary: "test parsed upper expression"
                    testLevelCBinary: null
                    testLevelDBinary: null
                output: "test parsed upper expression"
            
            run
                description: "unary expression with precedence over binary"
                parsesUnaryTo:
                    testLevelAUnary: null
                    testLevelBUnary: "test parsed upper expression"
                    testLevelCUnary: null
                    testLevelDUnary: null
                parsesBinaryTo:
                    testLevelABinary: null
                    testLevelBBinary: null
                    testLevelCBinary: "test parsed lower expression"
                    testLevelDBinary: null
                output: "test parsed upper expression"
                
            run
                description: "unary expression with precedence over binary on same level"
                parsesUnaryTo:
                    testLevelAUnary: null
                    testLevelBUnary: null
                    testLevelCUnary: "test parsed upper expression"
                    testLevelDUnary: null
                parsesBinaryTo:
                    testLevelABinary: null
                    testLevelBBinary: null
                    testLevelCBinary: "test parsed lower expression"
                    testLevelDBinary: null
                output: "test parsed upper expression"
    
            run
                description: "binary expression with precedence over binary"
                parsesUnaryTo:
                    testLevelAUnary: null
                    testLevelBUnary: null
                    testLevelCUnary: null
                    testLevelDUnary: null
                parsesBinaryTo:
                    testLevelABinary: null
                    testLevelBBinary: "test parsed upper expression"
                    testLevelCBinary: "test parsed lower expression"
                    testLevelDBinary: null
                output: "test parsed upper expression"
                
    describe "integration", ->
        expressionParse = rewire "./parse"
        tokenize = rewire "./../tokenize"
        run = (config) ->
            describe config.description, ->
                if config.throws
                    it "throws the expected exception", -> (expect -> expressionParse tokenize config.input).toThrow config.throws
                else
                    it "returns the expected expression tree", -> (expect expressionParse tokenize config.input).toEqual config.output

        run
            description: "operator precedence"
            input: "4.32 * 8.125 + 9. * .25"
            output:
                call: "add"
                starts: 13
                ends: 13
                with: [
                        call: "multiply"
                        starts: 5
                        ends: 5
                        with: [
                                primitive: "float"
                                value: 4.32
                                starts: 0
                                ends: 3
                            ,
                                primitive: "float"
                                value: 8.125
                                starts: 7
                                ends: 11
                        ]
                    ,
                        call: "multiply"
                        starts: 18
                        ends: 18
                        with: [
                                primitive: "float"
                                value: 9
                                starts: 15
                                ends: 16
                            ,
                                primitive: "float"
                                value: 0.25
                                starts: 20
                                ends: 22
                        ]
                ]
                
        run
            description: "operator precedence with parentheses to reinforce"
            input: "((4.32 * 8.125) + (9. * .25))"
            output:
                call: "add"
                starts: 16
                ends: 16
                with: [
                        call: "multiply"
                        starts: 7
                        ends: 7
                        with: [
                                primitive: "float"
                                value: 4.32
                                starts: 2
                                ends: 5
                            ,
                                primitive: "float"
                                value: 8.125
                                starts: 9
                                ends: 13
                        ]
                    ,
                        call: "multiply"
                        starts: 22
                        ends: 22
                        with: [
                                primitive: "float"
                                value: 9
                                starts: 19
                                ends: 20
                            ,
                                primitive: "float"
                                value: 0.25
                                starts: 24
                                ends: 26
                        ]
                ]
                
        run
            description: "operator precedence overridden with parentheses"
            input: "4.32 * (8.125 + 9.) * .25"
            output:
                call: "multiply"
                starts: 5
                ends: 5
                with: [
                        primitive: "float"
                        value: 4.32
                        starts: 0
                        ends: 3
                    ,
                        call: "multiply"
                        starts: 20
                        ends: 20
                        with: [
                                call: "add"
                                starts: 14
                                ends: 14
                                with: [
                                        primitive: "float"
                                        value: 8.125
                                        starts: 8
                                        ends: 12
                                    ,
                                        primitive: "float"
                                        value: 9
                                        starts: 16
                                        ends: 17
                                ]
                            ,
                                primitive: "float"
                                value: 0.25
                                starts: 22
                                ends: 24
                        ]
                ]
                
        run
            description: "invalid literal"
            input: "4.32 * 8..125 + 9. * .25"
            throws:
                reason: "invalidExpression"
                starts: 7
                ends: 12
                
        run
            description: "unary used as binary"
            input: "false and true ! false or true"
            throws:
                reason: "invalidExpression"
                starts: 10
                ends: 21
                
        run
            description: "double binary"
            input: "false and true or or false or true"
            throws:
                reason: "invalidExpression"
                starts: 18
                ends: 25
                
        run
            description: "complex scenario"
            input: "false and not 4.7 < 8.4 + -3.1 or -8 * 9 is 2 * 4 + 7 * 8 and false != true"
            output:
                call: "and"
                starts: 6
                ends: 8
                with: [
                        primitive: "boolean"
                        value: false
                        starts: 0
                        ends: 4
                    ,
                        call: "and"
                        starts: 58
                        ends: 60
                        with: [
                                call: "not"
                                starts: 10
                                ends: 12
                                with: [
                                    call: "or"
                                    starts: 31
                                    ends: 32
                                    with: [
                                            call: "lessThan"
                                            starts: 18
                                            ends: 18
                                            with: [
                                                    primitive: "float"
                                                    value: 4.7
                                                    starts: 14
                                                    ends: 16
                                                ,
                                                    call: "add"
                                                    starts: 24
                                                    ends: 24
                                                    with: [
                                                            primitive: "float"
                                                            value: 8.4
                                                            starts: 20
                                                            ends: 22
                                                        ,
                                                            call: "negate"
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
                                            call: "equal"
                                            starts: 41
                                            ends: 42
                                            with: [
                                                    call: "multiply"
                                                    starts: 37
                                                    ends: 37
                                                    with: [
                                                            call: "negate"
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
                                                    call: "add"
                                                    starts: 50
                                                    ends: 50
                                                    with: [
                                                            call: "multiply"
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
                                                            call: "multiply"
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
                                call: "notEqual"
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