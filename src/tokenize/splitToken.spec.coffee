describe "tokenize", -> describe "splitToken", ->
    rewire = require "rewire"
    describe "imports", ->
        tokenizeSplitToken = rewire "./splitToken"
        it "symbols", -> (expect tokenizeSplitToken.__get__ "symbols").toBe require "./symbols"
        
    describe "on calling", ->
        tokenizeSplitToken = rewire "./splitToken"
        
        symbols = [
            "=&+"
            "=&**>"
            "=&**"
            "&**>"
            ">"
            "="
            "=&-"
            "!**}"
        ]
        
        run = (config) ->
            describe config.description, ->
                result = inputCopy = symbolsCopy = undefined
                
                beforeEach ->
                    symbolsCopy = JSON.parse JSON.stringify symbols
                    tokenizeSplitToken.__set__ "symbols", symbolsCopy
                    
                    inputCopy = JSON.parse JSON.stringify config.input
                    result = tokenizeSplitToken inputCopy
                    
                it "does not change symbols", -> (expect symbolsCopy).toEqual symbols
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
                it "returns the expected result", -> (expect result).toEqual config.output
                
        run 
            description: "no symbol match"
            input:
                token: "notoken$matche5"
                starts: 5
            output: [
                token: "notoken$matche5"
                starts: 5
            ]
            
        run 
            description: "partial symbol start match"
            input:
                token: "notoken$ma!**e5"
                starts: 5
            output: [
                token: "notoken$ma!**e5"
                starts: 5
            ]
            
        run 
            description: "partial symbol end match"
            input:
                token: "notoken$mat**}5"
                starts: 5
            output: [
                token: "notoken$mat**}5"
                starts: 5
            ]

        run 
            description: "long symbol only"
            input:
                token: "=&**>"
                starts: 5
            output: [
                token: "=&**>"
                starts: 5
            ]
            
        run 
            description: "long symbol match in middle of token"
            input:
                token: "notoken$=&**>m5"
                starts: 5
            output: [
                    token: "notoken$"
                    starts: 5
                ,
                    token: "=&**>"
                    starts: 13
                ,
                    token: "m5"
                    starts: 18
            ]
            
        run 
            description: "long symbol match at the start of token"
            input:
                token: "=&**>notoken$m5"
                starts: 5
            output: [
                    token: "=&**>"
                    starts: 5
                ,
                    token: "notoken$m5"
                    starts: 10
            ]
            
        run 
            description: "long symbol match at the end of token"
            input:
                token: "notoken$m5=&**>"
                starts: 5
            output: [
                    token: "notoken$m5"
                    starts: 5
                ,
                    token: "=&**>"
                    starts: 15
            ]
            
        run 
            description: "long symbol match in middle of token with short symbol to left"
            input:
                token: "not>ken$=&**>m5"
                starts: 5
            output: [
                    token: "not"
                    starts: 5
                ,
                    token: ">"
                    starts: 8
                ,
                    token: "ken$"
                    starts: 9
                ,
                    token: "=&**>"
                    starts: 13
                ,
                    token: "m5"
                    starts: 18
            ]
            
        run 
            description: "long symbol match in middle of token with short symbol far to left"
            input:
                token: ">notken$=&**>m5"
                starts: 5
            output: [
                    token: ">"
                    starts: 5
                ,
                    token: "notken$"
                    starts: 6
                ,
                    token: "=&**>"
                    starts: 13
                ,
                    token: "m5"
                    starts: 18
            ]
            
        run 
            description: "long symbol match in middle of token with short symbol immediately to left"
            input:
                token: "notken$>=&**>m5"
                starts: 5
            output: [
                    token: "notken$"
                    starts: 5
                ,
                    token: ">"
                    starts: 12
                ,
                    token: "=&**>"
                    starts: 13
                ,
                    token: "m5"
                    starts: 18
            ]
            
        run 
            description: "long symbol match in middle of token with double short symbol to left"
            input:
                token: "not>>ken$=&**>m5"
                starts: 5
            output: [
                    token: "not"
                    starts: 5
                ,
                    token: ">"
                    starts: 8
                ,
                    token: ">"
                    starts: 9
                ,
                    token: "ken$"
                    starts: 10
                ,
                    token: "=&**>"
                    starts: 14
                ,
                    token: "m5"
                    starts: 19
            ]
            
        run 
            description: "long symbol match in middle of token with double differing short symbol to left"
            input:
                token: "not>=ken$=&**>m5"
                starts: 5
            output: [
                    token: "not"
                    starts: 5
                ,
                    token: ">"
                    starts: 8
                ,
                    token: "="
                    starts: 9
                ,
                    token: "ken$"
                    starts: 10
                ,
                    token: "=&**>"
                    starts: 14
                ,
                    token: "m5"
                    starts: 19
            ]
            
        run 
            description: "long symbol match in middle of token with two short symbols to left"
            input:
                token: "n>ot>ken$=&**>m5"
                starts: 5
            output: [
                    token: "n"
                    starts: 5
                ,
                    token: ">"
                    starts: 6
                ,
                    token: "ot"
                    starts: 7
                ,
                    token: ">"
                    starts: 9
                ,
                    token: "ken$"
                    starts: 10
                ,
                    token: "=&**>"
                    starts: 14
                ,
                    token: "m5"
                    starts: 19
            ]
            
        run 
            description: "long symbol match in middle of token with two differing short symbols to left"
            input:
                token: "n>ot=ken$=&**>m5"
                starts: 5
            output: [
                    token: "n"
                    starts: 5
                ,
                    token: ">"
                    starts: 6
                ,
                    token: "ot"
                    starts: 7
                ,
                    token: "="
                    starts: 9
                ,
                    token: "ken$"
                    starts: 10
                ,
                    token: "=&**>"
                    starts: 14
                ,
                    token: "m5"
                    starts: 19
            ]
            
        run 
            description: "long symbol match in middle of token with short symbol only to left"
            input:
                token: ">=&**>m5"
                starts: 5
            output: [
                    token: ">"
                    starts: 5
                ,
                    token: "=&**>"
                    starts: 6
                ,
                    token: "m5"
                    starts: 11
            ]
            
        run 
            description: "long symbol match in middle of token with short symbol to the right"
            input:
                token: "notken$=&**>m>5"
                starts: 5
            output: [
                    token: "notken$"
                    starts: 5
                ,
                    token: "=&**>"
                    starts: 12
                ,
                    token: "m"
                    starts: 17
                ,
                    token: ">"
                    starts: 18
                ,
                    token: "5"
                    starts: 19
            ]
            
        run 
            description: "long symbol match in middle of token with short symbol immediately to the right"
            input:
                token: "notken$=&**>>m5"
                starts: 5
            output: [
                    token: "notken$"
                    starts: 5
                ,
                    token: "=&**>"
                    starts: 12
                ,
                    token: ">"
                    starts: 17
                ,
                    token: "m5"
                    starts: 18
            ]
            
        run 
            description: "long symbol match in middle of token with short symbol far to the right"
            input:
                token: "notken$=&**>m5>"
                starts: 5
            output: [
                    token: "notken$"
                    starts: 5
                ,
                    token: "=&**>"
                    starts: 12
                ,
                    token: "m5"
                    starts: 17
                ,
                    token: ">"
                    starts: 19
            ]
            
        run 
            description: "long symbol match in middle of token with double short symbol to the right"
            input:
                token: "notken$=&**>m5>>"
                starts: 5
            output: [
                    token: "notken$"
                    starts: 5
                ,
                    token: "=&**>"
                    starts: 12
                ,
                    token: "m5"
                    starts: 17
                ,
                    token: ">"
                    starts: 19
                ,
                    token: ">"
                    starts: 20
            ]
            
        run 
            description: "long symbol match in middle of token with two short symbols to the right"
            input:
                token: "notken$=&**>m>5>"
                starts: 5
            output: [
                    token: "notken$"
                    starts: 5
                ,
                    token: "=&**>"
                    starts: 12
                ,
                    token: "m"
                    starts: 17
                ,
                    token: ">"
                    starts: 18
                ,
                    token: "5"
                    starts: 19
                ,
                    token: ">"
                    starts: 20
            ]
            
        run 
            description: "long symbol match in middle of token with double differing short symbol to the right"
            input:
                token: "notken$=&**>m5>="
                starts: 5
            output: [
                    token: "notken$"
                    starts: 5
                ,
                    token: "=&**>"
                    starts: 12
                ,
                    token: "m5"
                    starts: 17
                ,
                    token: ">"
                    starts: 19
                ,
                    token: "="
                    starts: 20
            ]
            
        run 
            description: "long symbol match in middle of token with two different short symbols to the right"
            input:
                token: "notken$=&**>m>5="
                starts: 5
            output: [
                    token: "notken$"
                    starts: 5
                ,
                    token: "=&**>"
                    starts: 12
                ,
                    token: "m"
                    starts: 17
                ,
                    token: ">"
                    starts: 18
                ,
                    token: "5"
                    starts: 19
                ,
                    token: "="
                    starts: 20
            ]