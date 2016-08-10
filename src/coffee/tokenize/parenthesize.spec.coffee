describe "tokenize", -> describe "parenthesize", ->
    rewire = require "rewire"
    describe "imports", ->
        tokenizeParenthesize = rewire "./parenthesize"
        it "parentheses", -> (expect tokenizeParenthesize.__get__ "parentheses").toBe require "./parentheses"
        
    describe "on calling", ->
        tokenizeParenthesize = rewire "./parenthesize"
        
        parentheses = 
            "openera": "closera"
            "openerb": "closerb"
        
        run = (config) ->
            describe config.description, ->
                result = inputCopy = parenthesesCopy = undefined
                
                beforeEach ->
                    parenthesesCopy = JSON.parse JSON.stringify parentheses
                    tokenizeParenthesize.__set__ "parentheses", parenthesesCopy
                    
                    inputCopy = JSON.parse JSON.stringify config.input
                
                if config.output
                    it "returns the expected result", -> (expect tokenizeParenthesize inputCopy).toEqual config.output
                else
                    it "throws the expected exception", -> (expect -> tokenizeParenthesize inputCopy).toThrow config.throws

                beforeEach -> 
                    try
                        tokenizeParenthesize inputCopy
                    catch
                    
                it "does not change parentheses", -> (expect parenthesesCopy).toEqual parentheses
                it "does not modify the input", -> (expect inputCopy).toEqual config.input

        run 
            description: "nothing"
            input: []
            output: []
                
        run 
            description: "one non-parenthesis"
            input: [
                token: "misca"
                starts: 5
            ]
            output: [
                token: "misca"
                starts: 5
                ends: 9
            ]
            
        run 
            description: "multiple non-parentheses"
            input: [
                    token: "misca"
                    starts: 5
                ,
                    token: "miscb"
                    starts: 17
                ,
                    token: "miscc"
                    starts: 39
            ]
            output: [
                    token: "misca"
                    starts: 5
                    ends: 9
                ,
                    token: "miscb"
                    starts: 17
                    ends: 21
                ,
                    token: "miscc"
                    starts: 39
                    ends: 43
            ]
            
        run 
            description: "ignores prototype keys"
            input: [
                    token: "misca"
                    starts: 5
                ,
                    token: "constructor"
                    starts: 17
                ,
                    token: "miscc"
                    starts: 39
            ]
            output: [
                    token: "misca"
                    starts: 5
                    ends: 9
                ,
                    token: "constructor"
                    starts: 17
                    ends: 27
                ,
                    token: "miscc"
                    starts: 39
                    ends: 43
            ]
        
        run 
            description: "one opening parenthesis"
            input: [
                token: "openera"
                starts: 5
            ]
            throws:
                reason: "unclosedParentheses"
                starts: 5
                ends: 11
                    
        run 
            description: "one closing parenthesis"
            input: [
                token: "closera"
                starts: 5
            ]
            throws:
                reason: "unopenedParentheses"
                starts: 5
                ends: 11
                    
        run 
            description: "empty parentheses"
            input: [
                    token: "openera"
                    starts: 5
                ,
                    token: "closera"
                    starts: 17
            ]
            output: [
                token: "openera"
                starts: 5
                ends: 23
                children: []
            ]
            
        run 
            description: "backwards empty parentheses"
            input: [
                    token: "closera"
                    starts: 5
                ,
                    token: "openera"
                    starts: 17
            ]
            throws:
                reason: "unopenedParentheses"
                starts: 5
                ends: 11
                    
        run 
            description: "empty parentheses closed twice"
            input: [
                    token: "openera"
                    starts: 5
                ,
                    token: "closera"
                    starts: 17
                ,
                    token: "closera"
                    starts: 39
            ]
            throws:
                reason: "unopenedParentheses"
                starts: 39
                ends: 45
        
        run 
            description: "empty parentheses opened twice"
            input: [
                    token: "openera"
                    starts: 5
                ,
                    token: "openera"
                    starts: 17
                ,
                    token: "closera"
                    starts: 39
            ]
            throws:
                reason: "unclosedParentheses"
                starts: 5
                ends: 45
        
        run 
            description: "empty parentheses closed with wrong parenthesis"
            input: [
                    token: "openera"
                    starts: 5
                ,
                    token: "closerb"
                    starts: 17
            ]
            throws:
                reason: "unopenedParentheses"
                starts: 17
                ends: 23
                    
        run 
            description: "double empty parentheses"
            input: [
                    token: "openera"
                    starts: 5
                ,
                    token: "closera"
                    starts: 17
                ,
                    token: "openera"
                    starts: 39
                ,
                    token: "closera"
                    starts: 61
            ]
            output: [
                    token: "openera"
                    starts: 5
                    ends: 23
                    children: []
                ,
                    token: "openera"
                    starts: 39
                    ends: 67
                    children: []
            ]
            
        run 
            description: "double differing empty parentheses"
            input: [
                    token: "openera"
                    starts: 5
                ,
                    token: "closera"
                    starts: 17
                ,
                    token: "openerb"
                    starts: 39
                ,
                    token: "closerb"
                    starts: 61
            ]
            output: [
                    token: "openera"
                    starts: 5
                    ends: 23
                    children: []
                ,
                    token: "openerb"
                    starts: 39
                    ends: 67
                    children: []
            ]
            
        run 
            description: "nested empty parentheses"
            input: [
                    token: "openera"
                    starts: 5
                ,
                    token: "openera"
                    starts: 17
                ,
                    token: "closera"
                    starts: 39
                ,
                    token: "closera"
                    starts: 61
            ]
            output: [
                token: "openera"
                starts: 5
                ends: 67
                children: [
                    token: "openera"
                    starts: 17
                    ends: 45
                    children: []
                ]
            ]
            
        run 
            description: "nested differing empty parentheses"
            input: [
                    token: "openera"
                    starts: 5
                ,
                    token: "openerb"
                    starts: 17
                ,
                    token: "closerb"
                    starts: 39
                ,
                    token: "closera"
                    starts: 61
            ]
            output: [
                token: "openera"
                starts: 5
                ends: 67
                children: [
                    token: "openerb"
                    starts: 17
                    ends: 45
                    children: []
                ]
            ]
            
        run 
            description: "interleaved parentheses"
            input: [
                    token: "openera"
                    starts: 5
                ,
                    token: "openerb"
                    starts: 17
                ,
                    token: "closera"
                    starts: 39
                ,
                    token: "closerb"
                    starts: 61
            ]
            throws:
                reason: "unopenedParentheses"
                starts: 39
                ends: 45
                    
        run 
            description: "complex scenario"
            input: [
                    token: "precedinga"
                    starts: 5
                ,
                    token: "precedingb"
                    starts: 27
                ,
                    token: "openera"
                    starts: 49
                ,
                    token: "insidelefta"
                    starts: 61
                ,
                    token: "insideleftb"
                    starts: 83
                ,
                    token: "insideleftc"
                    starts: 105
                ,
                    token: "openerb"
                    starts: 127
                ,
                    token: "deeplefta"
                    starts: 149
                ,
                    token: "deepleftb"
                    starts: 161
                ,
                    token: "deepleftc"
                    starts: 183
                ,
                    token: "closerb"
                    starts: 205
                ,
                    token: "middle"
                    starts: 227
                ,
                    token: "openerb"
                    starts: 249
                ,
                    token: "deeprighta"
                    starts: 261
                ,
                    token: "deeprightb"
                    starts: 283
                ,
                    token: "closerb"
                    starts: 305
                ,
                    token: "insiderighta"
                    starts: 327
                ,
                    token: "insiderightb"
                    starts: 349
                ,
                    token: "closera"
                    starts: 361
                ,
                    token: "trailinga"
                    starts: 383
                ,
                    token: "trailingb"
                    starts: 405
                ,
                    token: "trailingc"
                    starts: 427                   
            ]
            output: [
                    token: "precedinga"
                    starts: 5
                    ends: 14
                ,
                    token: "precedingb"
                    starts: 27
                    ends: 36
                ,
                    token: "openera"
                    starts: 49
                    ends: 367
                    children: [
                            token: "insidelefta"
                            starts: 61
                            ends: 71
                        ,
                            token: "insideleftb"
                            starts: 83
                            ends: 93
                        ,
                            token: "insideleftc"
                            starts: 105
                            ends: 115
                        ,
                            token: "openerb"
                            starts: 127
                            ends: 211
                            children: [
                                    token: "deeplefta"
                                    starts: 149
                                    ends: 157
                                ,
                                    token: "deepleftb"
                                    starts: 161
                                    ends: 169
                                ,
                                    token: "deepleftc"
                                    starts: 183
                                    ends: 191
                            ]
                        ,
                            token: "middle"
                            starts: 227
                            ends: 232
                        ,
                            token: "openerb"
                            starts: 249
                            ends: 311
                            children: [
                                    token: "deeprighta"
                                    starts: 261
                                    ends: 270
                                ,
                                    token: "deeprightb"
                                    starts: 283
                                    ends: 292
                            ]
                        ,
                            token: "insiderighta"
                            starts: 327
                            ends: 338
                        ,
                            token: "insiderightb"
                            starts: 349
                            ends: 360
                    ]
                ,
                    token: "trailinga"
                    starts: 383
                    ends: 391
                ,
                    token: "trailingb"
                    starts: 405
                    ends: 413
                ,
                    token: "trailingc"
                    starts: 427 
                    ends: 435
            ]