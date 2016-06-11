describe "expression", -> describe "parse", -> describe "float", ->
    rewire = require "rewire"
    describe "on calling", ->
        expressionParseFloat = rewire "./float"
        run = (config) ->
            describe config.description, ->
                result = inputCopy = undefined
                beforeEach ->                    
                    inputCopy = JSON.parse JSON.stringify config.input
                    result = expressionParseFloat inputCopy
                it "returns the expected result", -> (expect result).toEqual config.output    
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
        run
            description: "period only"
            input: [
                token: "."
                starts: 35
                ends: 74
            ]
            output: null
        run
            description: "zero only"
            input: [
                token: "0"
                starts: 35
                ends: 74
            ]
            output: null
        run
            description: "single digit only"
            input: [
                token: "6"
                starts: 35
                ends: 74
            ]
            output: null
        describe "integer and fractional", ->
            describe "integer single zero", ->
                run
                    description: "preceding token"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "0"
                            starts: 87
                            ends: 96
                        ,
                            token: "."
                            starts: 122
                            ends: 146
                        ,
                            token: "0"
                            starts: 166
                            ends: 180
                    ]
                    output: null
                run
                    description: "trailing token"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                        ,
                            token: "0"
                            starts: 166
                            ends: 180
                    ]
                    output: null
                run
                    description: "invalid decimal point"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "?"
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional single zero"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.7
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.007
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.00745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "0"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
            describe "integer multiple zeroes", ->
                run
                    description: "fractional single zero"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.7
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.007
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.00745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 0.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "000"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
            describe "integer single digit", ->
                run
                    description: "fractional single zero"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.7
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.007
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.745
                        starts: 35
                        ends: 146                        
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.00745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
            describe "integer multiple digits", ->
                run
                    description: "fractional single zero"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 926
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 926
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 926.7
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 926.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 926.007
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 926.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 926.00745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 926.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "926"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
            describe "integer single digit preceded by zeroes", ->
                run
                    description: "fractional single zero"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.7
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.007
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.00745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 9.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "009"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
            describe "integer single digit followed by zeroes", ->
                run
                    description: "fractional single zero"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 900
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 900
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 900.7
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 900.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 900.007
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 900.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 900.00745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 900.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "900"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
            describe "integer multiple digits preceded by zeroes", ->
                run
                    description: "fractional single zero"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 923
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 923
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 923.7
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 923.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 923.007
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 923.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 923.00745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146                            
                    ]
                    output:
                        primitive: "float"
                        value: 923.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "00923"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
            describe "integer multiple digits followed by zeroes", ->
                run
                    description: "fractional single zero"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 92300
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 92300
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 92300.7
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 92300.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 92300.007
                        starts: 35
                        ends: 146
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 92300.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 92300.00745
                        starts: 35
                        ends: 146
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output:
                        primitive: "float"
                        value: 92300.745
                        starts: 35
                        ends: 146
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "92300"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
            describe "integer non-digit before digit", ->
                run
                    description: "fractional single zero"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional single digit"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "d9"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
            describe "integer non-digit after digit", ->
                run
                    description: "fractional single zero"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional single digit"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "9d"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
            describe "integer non-digit between digits", ->
                run
                    description: "fractional single zero"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "0"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple zeroes"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "000"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional single digit"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple digits"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "745"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional single digit preceded by zeroes"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "007"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional single digit followed by zeroes"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple digits preceded by zeroes"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "00745"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional multiple digits followed by zeroes"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "74500"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit before digit"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "t7"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit after digit"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t"
                            starts: 122
                            ends: 146
                    ]
                    output: null
                run
                    description: "fractional non-digit between digits"
                    input: [
                            token: "9d2"
                            starts: 35
                            ends: 74
                        ,
                            token: "."
                            starts: 87
                            ends: 96
                        ,
                            token: "7t5"
                            starts: 122
                            ends: 146
                    ]
                    output: null
        describe "integer only", ->
            run
                description: "preceding tokens"
                input: [
                        token: "0"
                        starts: 35
                        ends: 74
                    ,
                        token: "0"
                        starts: 87
                        ends: 96
                    ,
                        token: "."
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "trailing tokens"
                input: [
                        token: "0"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                    ,
                        token: "L"
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "invalid decimal point"
                input: [
                        token: "0"
                        starts: 35
                        ends: 74
                    ,
                        token: "?"
                        starts: 87
                        ends: 96
                ]
                output: null
            run
                description: "zero"
                input: [
                        token: "0"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 0
                    starts: 35
                    ends: 96
            run
                description: "multiple zeroes"
                input: [
                        token: "000"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 0
                    starts: 35
                    ends: 96
            run
                description: "single digit"
                input: [
                        token: "4"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 4
                    starts: 35
                    ends: 96
            run
                description: "multiple digits"
                input: [
                        token: "478"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 478
                    starts: 35
                    ends: 96
            run
                description: "single digit preceded by zeroes"
                input: [
                        token: "004"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 4
                    starts: 35
                    ends: 96
            run
                description: "multiple digits preceded by zeroes"
                input: [
                        token: "00478"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 478
                    starts: 35
                    ends: 96
            run
                description: "single digit followed by zeroes"
                input: [
                        token: "400"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 400
                    starts: 35
                    ends: 96
            run
                description: "multiple digits followed by zeroes"
                input: [
                        token: "47800"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 47800
                    starts: 35
                    ends: 96
            run
                description: "non-digit before digit"
                input: [
                        token: "t0"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output: null
            run
                description: "non-digit after digit"
                input: [
                        token: "0t"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output: null
            run
                description: "non-digit between digits"
                input: [
                        token: "4t5"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                ]
                output: null
        describe "fractional only", ->
            run
                description: "preceding tokens"
                input: [
                        token: "L"
                        starts: 35
                        ends: 74
                    ,
                        token: "."
                        starts: 87
                        ends: 96
                    ,
                        token: "0"
                ]
                output: null
            run
                description: "trailing tokens"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "0"
                        starts: 87
                        ends: 96
                    ,
                        token: "0"
                        starts: 122
                        ends: 146
                ]
                output: null
            run
                description: "invalid decimal point"
                input: [
                        token: "?"
                        starts: 35
                        ends: 74
                    ,
                        token: "0"
                        starts: 87
                        ends: 96
                ]
                output: null
            run
                description: "zero"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "0"
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 0
                    starts: 35
                    ends: 96
            run
                description: "multiple zeroes"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "000"
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 0
                    starts: 35
                    ends: 96
            run
                description: "single digit"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "4"
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 0.4
                    starts: 35
                    ends: 96
            run
                description: "multiple digits"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "478"
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 0.478
                    starts: 35
                    ends: 96
            run
                description: "single digit preceded by zeroes"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "004"
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 0.004
                    starts: 35
                    ends: 96
            run
                description: "multiple digits preceded by zeroes"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "00478"
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 0.00478
                    starts: 35
                    ends: 96
            run
                description: "single digit followed by zeroes"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "400"
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 0.4
                    starts: 35
                    ends: 96
            run
                description: "multiple digits followed by zeroes"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "47800"
                        starts: 87
                        ends: 96
                ]
                output:
                    primitive: "float"
                    value: 0.478
                    starts: 35
                    ends: 96
            run
                description: "non-digit before digit"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "t0"
                        starts: 87
                        ends: 96
                ]
                output: null
            run
                description: "non-digit after digit"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "0t"
                        starts: 87
                        ends: 96
                ]
                output: null
            run
                description: "non-digit between digits"
                input: [
                        token: "."
                        starts: 35
                        ends: 74
                    ,
                        token: "4t5"
                        starts: 87
                        ends: 96
                ]
                output: null