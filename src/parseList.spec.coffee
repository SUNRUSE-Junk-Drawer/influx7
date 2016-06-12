describe "parseList", ->
    parseList = require "./parseList"
    run = (config) ->
        describe config.description, ->
            inputCopy = undefined
            beforeEach ->
                inputCopy = JSON.parse JSON.stringify config.input
            if config.throws
                it "throws the expected exception", -> (expect -> parseList inputCopy, "test deliminator").toThrow config.throws
            else
                it "returns the expected output", -> (expect parseList inputCopy, "test deliminator").toEqual config.output
                
            beforeEach ->
                try
                    parseList inputCopy, "test deliminator"
                catch
            it "does not modify the input", -> (expect inputCopy).toEqual config.input
    run 
        description: "no tokens"
        input: []
        output: [] 
    run 
        description: "a single token"
        input: [
            token: "test token one"
            misc: "test miscellaneous data one"
            starts: 15
            ends: 37
        ]
        output: [
            [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 15
                ends: 37
            ]
        ] 
    run 
        description: "multiple tokens without deliminators"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 15
                ends: 37
            ,
                token: "test token two"
                misc: "test miscellaneous data two"
                starts: 52
                ends: 73
            ,
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 123
                ends: 160
        ]
        output: [
            [
                    token: "test token one"
                    misc: "test miscellaneous data one"
                    starts: 15
                    ends: 37
                ,
                    token: "test token two"
                    misc: "test miscellaneous data two"
                    starts: 52
                    ends: 73
                ,
                    token: "test token three"
                    misc: "test miscellaneous data three"
                    starts: 123
                    ends: 160
            ]
        ] 
    run 
        description: "a single deliminator"
        input: [
            token: "test deliminator"
            misc: "test miscellaneous data one"
            starts: 17
            ends: 25
        ]
        throws:
            reason: "emptyGroup"
            starts: 17
            ends: 25
    run 
        description: "two deliminators"
        input: [
                token: "test deliminator"
                misc: "test miscellaneous data one"
                starts: 17
                ends: 25
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 31
                ends: 56
        ]
        throws:
            reason: "emptyGroup"
            starts: 17
            ends: 25
    run 
        description: "one token then a single deliminator"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 3
                ends: 8
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 17
                ends: 25
        ]
        throws:
            reason: "emptyGroup"
            starts: 17
            ends: 25
    run 
        description: "multiple tokens then a single deliminator"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test token two"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
            ,
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 60
                ends: 84
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 112
                ends: 148
        ]
        throws:
            reason: "emptyGroup"
            starts: 112
            ends: 148
    run 
        description: "single deliminator then a single token"
        input: [
                token: "test deliminator"
                misc: "test miscellaneous data one"
                starts: 17
                ends: 25
            ,
                token: "test token two"
                misc: "test miscellaneous data two"
                starts: 36
                ends: 41
        ]
        throws:
            reason: "emptyGroup"
            starts: 17
            ends: 25
    run 
        description: "single deliminator then multiple tokens"
        input: [
                token: "test deliminator"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test token one"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
            ,
                token: "test token two"
                misc: "test miscellaneous data three"
                starts: 60
                ends: 84
            ,
                token: "test token three"
                misc: "test miscellaneous data two"
                starts: 112
                ends: 148
        ]
        throws:
            reason: "emptyGroup"
            starts: 13
            ends: 27
    run 
        description: "single token then a single deliminator then a single token"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 3
                ends: 5
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 17
                ends: 25
            ,
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 36
                ends: 41
        ]
        output: [
            [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 3
                ends: 5
            ]
            [
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 36
                ends: 41
            ]
        ]
    run 
        description: "multiple tokens then a single deliminator then a single token"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 3
                ends: 5
            ,
                token: "test token two"
                misc: "test miscellaneous data two"
                starts: 24
                ends: 27
            ,
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 34
                ends: 39
            ,
                token: "test deliminator"
                misc: "test miscellaneous data four"
                starts: 58
                ends: 72
            ,
                token: "test token five"
                misc: "test miscellaneous data five"
                starts: 101
                ends: 140
        ]
        output: [
            [
                    token: "test token one"
                    misc: "test miscellaneous data one"
                    starts: 3
                    ends: 5
                ,
                    token: "test token two"
                    misc: "test miscellaneous data two"
                    starts: 24
                    ends: 27
                ,
                    token: "test token three"
                    misc: "test miscellaneous data three"
                    starts: 34
                    ends: 39
            ]
            [
                token: "test token five"
                misc: "test miscellaneous data five"
                starts: 101
                ends: 140
            ]
        ]
    run 
        description: "a single token then a single deliminator then multiple tokens"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 3
                ends: 5
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 24
                ends: 37
            ,
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 49
                ends: 57
            ,
                token: "test token four"
                misc: "test miscellaneous data four"
                starts: 78
                ends: 88
            ,
                token: "test token five"
                misc: "test miscellaneous data five"
                starts: 101
                ends: 140
        ]
        output: [
            [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 3
                ends: 5
            ]
            [
                    token: "test token three"
                    misc: "test miscellaneous data three"
                    starts: 49
                    ends: 57
                ,
                    token: "test token four"
                    misc: "test miscellaneous data four"
                    starts: 78
                    ends: 88
                ,
                    token: "test token five"
                    misc: "test miscellaneous data five"
                    starts: 101
                    ends: 140
            ]
        ]
    run 
        description: "multiple tokens then a single deliminator then multiple tokens"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 3
                ends: 5
            ,
                token: "test token two"
                misc: "test miscellaneous data two"
                starts: 24
                ends: 27
            ,
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 34
                ends: 39
            ,
                token: "test deliminator"
                misc: "test miscellaneous data four"
                starts: 58
                ends: 72
            ,
                token: "test token five"
                misc: "test miscellaneous data five"
                starts: 101
                ends: 140
            ,
                token: "test token six"
                misc: "test miscellaneous data six"
                starts: 163
                ends: 174
        ]
        output: [
            [
                    token: "test token one"
                    misc: "test miscellaneous data one"
                    starts: 3
                    ends: 5
                ,
                    token: "test token two"
                    misc: "test miscellaneous data two"
                    starts: 24
                    ends: 27
                ,
                    token: "test token three"
                    misc: "test miscellaneous data three"
                    starts: 34
                    ends: 39
            ]
            [
                    token: "test token five"
                    misc: "test miscellaneous data five"
                    starts: 101
                    ends: 140
                ,
                    token: "test token six"
                    misc: "test miscellaneous data six"
                    starts: 163
                    ends: 174
            ]
        ]
    run 
        description: "two deliminators"
        input: [
                token: "test deliminator"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
        ]
        throws:
            reason: "emptyGroup"
            starts: 13
            ends: 27
    run 
        description: "a single token then two deliminators"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
            ,
                token: "test deliminator"
                misc: "test miscellaneous data three"
                starts: 65
                ends: 89
        ]
        throws:
            reason: "emptyGroup"
            starts: 35
            ends: 89
    run 
        description: "a deliminator then a single token then a deliminator"
        input: [
                token: "test deliminator"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test token two"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
            ,
                token: "test deliminator"
                misc: "test miscellaneous data three"
                starts: 65
                ends: 89
        ]
        throws:
            reason: "emptyGroup"
            starts: 13
            ends: 27
    run 
        description: "two deliminators then a single toke"
        input: [
                token: "test deliminator"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
            ,
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 65
                ends: 89
        ]
        throws:
            reason: "emptyGroup"
            starts: 13
            ends: 27
    run 
        description: "a single token then a deliminator then a single token then a deliminator"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
            ,
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 65
                ends: 89
            ,
                token: "test deliminator"
                misc: "test miscellaneous data four"
                starts: 124
                ends: 148
        ]
        throws:
            reason: "emptyGroup"
            starts: 124
            ends: 148
    run 
        description: "a single token then two deliminators then a single token"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
            ,
                token: "test deliminator"
                misc: "test miscellaneous data three"
                starts: 65
                ends: 89
            ,
                token: "test token four"
                misc: "test miscellaneous data four"
                starts: 124
                ends: 148
        ]
        throws:
            reason: "emptyGroup"
            starts: 35
            ends: 89
    run 
        description: "a deliminator then a single token then a deliminator then a single token"
        input: [
                token: "test deliminator"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test token two"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
            ,
                token: "test deliminator"
                misc: "test miscellaneous data three"
                starts: 65
                ends: 89
            ,
                token: "test token four"
                misc: "test miscellaneous data four"
                starts: 124
                ends: 148
        ]
        throws:
            reason: "emptyGroup"
            starts: 13
            ends: 27
    run 
        description: "a single token then a deliminator then a single token then a deliminator then a single token"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test deliminator"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
            ,
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 65
                ends: 89
            ,
                token: "test deliminator"
                misc: "test miscellaneous data four"
                starts: 124
                ends: 148
            ,
                token: "test token five"
                misc: "test miscellaneous data five"
                starts: 167
                ends: 184
        ]
        output: [
            [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ]
            [
                token: "test token three"
                misc: "test miscellaneous data three"
                starts: 65
                ends: 89
            ]
            [
                token: "test token five"
                misc: "test miscellaneous data five"
                starts: 167
                ends: 184
            ]
        ]
    run 
        description: "multiple tokens then a deliminator then multiple tokens then a deliminator then multiple tokens"
        input: [
                token: "test token one"
                misc: "test miscellaneous data one"
                starts: 13
                ends: 27
            ,
                token: "test token two"
                misc: "test miscellaneous data two"
                starts: 35
                ends: 47
            ,
                token: "test deliminator"
                misc: "test miscellaneous data three"
                starts: 65
                ends: 89
            ,
                token: "test token four"
                misc: "test miscellaneous data four"
                starts: 124
                ends: 148
            ,
                token: "test token five"
                misc: "test miscellaneous data five"
                starts: 167
                ends: 184
            ,
                token: "test token six"
                misc: "test miscellaneous data six"
                starts: 204
                ends: 248
            ,
                token: "test deliminator"
                misc: "test miscellaneous data seven"
                starts: 265
                ends: 283
            ,
                token: "test token eight"
                misc: "test miscellaneous data eight"
                starts: 292
                ends: 301
            ,
                token: "test token nine"
                misc: "test miscellaneous data nine"
                starts: 314
                ends: 348
        ]
        output: [
            [
                    token: "test token one"
                    misc: "test miscellaneous data one"
                    starts: 13
                    ends: 27
                ,
                    token: "test token two"
                    misc: "test miscellaneous data two"
                    starts: 35
                    ends: 47
            ]
            [
                    token: "test token four"
                    misc: "test miscellaneous data four"
                    starts: 124
                    ends: 148
                ,
                    token: "test token five"
                    misc: "test miscellaneous data five"
                    starts: 167
                    ends: 184
                ,
                    token: "test token six"
                    misc: "test miscellaneous data six"
                    starts: 204
                    ends: 248
            ]
            [
                    token: "test token eight"
                    misc: "test miscellaneous data eight"
                    starts: 292
                    ends: 301
                ,
                    token: "test token nine"
                    misc: "test miscellaneous data nine"
                    starts: 314
                    ends: 348
            ]
        ]