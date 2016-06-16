describe "statement", -> describe "parse", -> describe "findNext", ->
    rewire = require "rewire"
    describe "imports", ->
        statementParseFindNext = rewire "./findNext"
        it "statementParseStatements", -> (expect statementParseFindNext.__get__ "statementParseStatements").toBe require "./statements"
    describe "on calling", ->
        statementParseFindNext = rewire "./findNext"
        statementParseStatements = 
            "test statement a": {}
            "test statement b": {}
            "test statement c": {}
            "test statement d": {}
        run = (config) ->
            describe config.description, ->
                result = inputCopy = statementParseStatementsCopy = undefined
                beforeEach -> 
                    statementParseStatementsCopy = JSON.parse JSON.stringify statementParseStatements
                    statementParseFindNext.__set__ "statementParseStatements", statementParseStatementsCopy
                    inputCopy = JSON.parse JSON.stringify config.input
                    result = statementParseFindNext inputCopy
                it "returns the expected output", -> (expect result).toEqual config.output
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
                it "does not modify statementParseStatements", -> (expect statementParseStatementsCopy).toEqual statementParseStatements
        run
            description: "empty"
            input: []
            output:
                statement: []
                next: []
        run
            description: "one non-statement"
            input: [
                token: "test non-statement one"
                misc: "test misc data one"
            ]
            output:
                statement: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ]
                next: []
        run
            description: "multiple non-statements"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: []
        run
            description: "one statement"
            input: [
                token: "test statement b"
                misc: "test misc data one"
            ]
            output:
                statement: []
                next: [
                    token: "test statement b"
                    misc: "test misc data one"
                ]
        run
            description: "one statement followed by the same statement"
            input: [
                    token: "test statement b"
                    misc: "test misc data one"
                ,
                    token: "test statement b"
                    misc: "test misc data two"
            ]
            output:
                statement: []
                next: [
                        token: "test statement b"
                        misc: "test misc data one"
                    ,
                        token: "test statement b"
                        misc: "test misc data two"
                ]
        run
            description: "one statement followed by another statement"
            input: [
                    token: "test statement b"
                    misc: "test misc data one"
                ,
                    token: "test statement c"
                    misc: "test misc data two"
            ]
            output:
                statement: []
                next: [
                        token: "test statement b"
                        misc: "test misc data one"
                    ,
                        token: "test statement c"
                        misc: "test misc data two"
                ]
        run
            description: "one non-statement followed by one statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test statement b"
                    misc: "test misc data two"
            ]
            output:
                statement: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ]
                next: [
                    token: "test statement b"
                    misc: "test misc data two"
                ]
        run
            description: "one non-statement followed by one statement followed by the same statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test statement b"
                    misc: "test misc data two"
                ,
                    token: "test statement b"
                    misc: "test misc data three"
            ]
            output:
                statement: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data two"
                    ,
                        token: "test statement b"
                        misc: "test misc data three"
                ]
        run
            description: "one non-statement followed by one statement followed by another statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test statement b"
                    misc: "test misc data two"
                ,
                    token: "test statement c"
                    misc: "test misc data three"
            ]
            output:
                statement: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data two"
                    ,
                        token: "test statement c"
                        misc: "test misc data three"
                ]
        run
            description: "multiple non-statements followed by one statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                    token: "test statement b"
                    misc: "test misc data four"
                ]
        run
            description: "multiple non-statements followed by one statement followed by the same statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test statement b"
                    misc: "test misc data five"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"

                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test statement b"
                        misc: "test misc data five"
                ]
        run
            description: "multiple non-statements followed by one statement followed by another statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test statement c"
                    misc: "test misc data five"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test statement c"
                        misc: "test misc data five"
                ]
        run
            description: "multiple non-statements followed by one statement followed by one non-statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                ]
        run
            description: "multiple non-statements followed by one statement followed by the same statement followed by one non-statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test statement b"
                    misc: "test misc data five"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"

                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test statement b"
                        misc: "test misc data five"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                ]
        run
            description: "multiple non-statements followed by one statement followed by another statement followed by one non-statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test statement c"
                    misc: "test misc data five"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test statement c"
                        misc: "test misc data five"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                ]
        run
            description: "multiple non-statements followed by one statement followed by multiple non-statements"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                ]
        run
            description: "multiple non-statements followed by one statement followed by the same statement followed by multiple non-statements"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test statement b"
                    misc: "test misc data five"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
                ,
                    token: "test non-statement seven"
                    misc: "test misc data seven"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test statement b"
                        misc: "test misc data five"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                    ,
                        token: "test non-statement seven"
                        misc: "test misc data seven"
                ]
        run
            description: "multiple non-statements followed by one statement followed by another statement followed by multiple non-statements"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test statement c"
                    misc: "test misc data five"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
                ,
                    token: "test non-statement seven"
                    misc: "test misc data seven"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test statement c"
                        misc: "test misc data five"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                    ,
                        token: "test non-statement seven"
                        misc: "test misc data seven"
                ] 
        run
            description: "multiple non-statements followed by one statement followed by one non-statement followed by the same statement followed by one non-statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test statement b"
                    misc: "test misc data six"
                ,
                    token: "test non-statement seven"
                    misc: "test misc data seven"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"

                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test statement b"
                        misc: "test misc data six"
                    ,
                        token: "test non-statement seven"
                        misc: "test misc data seven"
                ]
        run
            description: "multiple non-statements followed by one statement followed by one non-statement followed by another statement followed by one non-statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test statement c"
                    misc: "test misc data six"
                ,
                    token: "test non-statement seven"
                    misc: "test misc data seven"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test statement c"
                        misc: "test misc data six"
                    ,
                        token: "test non-statement seven"
                        misc: "test misc data seven"
                ]
        run
            description: "multiple non-statements followed by one statement followed by one non-statement followed by the same statement followed by multiple non-statements"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test statement b"
                    misc: "test misc data six"
                ,
                    token: "test non-statement seven"
                    misc: "test misc data seven"
                ,
                    token: "test non-statement eight"
                    misc: "test misc data eight"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test statement b"
                        misc: "test misc data six"
                    ,
                        token: "test non-statement seven"
                        misc: "test misc data seven"
                    ,
                        token: "test non-statement eight"
                        misc: "test misc data eight"
                ]
        run
            description: "multiple non-statements followed by one statement followed by one non-statement followed by another statement followed by multiple non-statements"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test statement c"
                    misc: "test misc data six"
                ,
                    token: "test non-statement seven"
                    misc: "test misc data seven"
                ,
                    token: "test non-statement eight"
                    misc: "test misc data eight"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test statement c"
                        misc: "test misc data six"
                    ,
                        token: "test non-statement seven"
                        misc: "test misc data seven"
                    ,
                        token: "test non-statement eight"
                        misc: "test misc data eight"
                ]
                
                
        run
            description: "multiple non-statements followed by one statement followed by multiple non-statements followed by the same statement followed by one non-statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test statement b"
                    misc: "test misc data fix"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
                ,
                    token: "test statement b"
                    misc: "test misc data seven"
                ,
                    token: "test non-statement eight"
                    misc: "test misc data eight"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"

                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test statement b"
                        misc: "test misc data fix"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                    ,
                        token: "test statement b"
                        misc: "test misc data seven"
                    ,
                        token: "test non-statement eight"
                        misc: "test misc data eight"
                ]
        run
            description: "multiple non-statements followed by one statement followed by multiple non-statements followed by another statement followed by one non-statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
                ,
                    token: "test statement c"
                    misc: "test misc data seven"
                ,
                    token: "test non-statement eight"
                    misc: "test misc data eight"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                    ,
                        token: "test statement c"
                        misc: "test misc data seven"
                    ,
                        token: "test non-statement eight"
                        misc: "test misc data eight"
                ]
        run
            description: "multiple non-statements followed by one statement followed by multiple non-statements followed by the same statement followed by multiple non-statements"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
                ,
                    token: "test statement b"
                    misc: "test misc data seven"
                ,
                    token: "test non-statement eight"
                    misc: "test misc data eight"
                ,
                    token: "test non-statement nine"
                    misc: "test misc data nine"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                    ,
                        token: "test statement b"
                        misc: "test misc data seven"
                    ,
                        token: "test non-statement eight"
                        misc: "test misc data eight"
                    ,
                        token: "test non-statement nine"
                        misc: "test misc data nine"
                ]
        run
            description: "multiple non-statements followed by one statement followed by multiple non-statements followed by another statement followed by multiple non-statements"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
                ,
                    token: "test statement c"
                    misc: "test misc data seven"
                ,
                    token: "test non-statement eight"
                    misc: "test misc data eight"
                ,
                    token: "test non-statement nine"
                    misc: "test misc data nine"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                    ,
                        token: "test statement c"
                        misc: "test misc data seven"
                    ,
                        token: "test non-statement eight"
                        misc: "test misc data eight"
                    ,
                        token: "test non-statement nine"
                        misc: "test misc data nine"
                ]
        run
            description: "multiple non-statements followed by one statement followed by one non-statement followed by the same statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test statement b"
                    misc: "test misc data six"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test statement b"
                        misc: "test misc data six"
                ]
        run
            description: "multiple non-statements followed by one statement followed by one non-statement followed by another statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test statement c"
                    misc: "test misc data six"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test statement c"
                        misc: "test misc data six"
                ]
        run
            description: "multiple non-statements followed by one statement followed by multiple non-statements followed by the same statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
                ,
                    token: "test statement b"
                    misc: "test misc data seven"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                    ,
                        token: "test statement b"
                        misc: "test misc data seven"
                ]
        run
            description: "multiple non-statements followed by one statement followed by multiple non-statements followed by another statement"
            input: [
                    token: "test non-statement one"
                    misc: "test misc data one"
                ,
                    token: "test non-statement two"
                    misc: "test misc data two"
                ,
                    token: "test non-statement three"
                    misc: "test misc data three"
                ,
                    token: "test statement b"
                    misc: "test misc data four"
                ,
                    token: "test non-statement five"
                    misc: "test misc data five"
                ,
                    token: "test non-statement six"
                    misc: "test misc data six"
                ,
                    token: "test statement c"
                    misc: "test misc data seven"
            ]
            output:
                statement: [
                        token: "test non-statement one"
                        misc: "test misc data one"
                    ,
                        token: "test non-statement two"
                        misc: "test misc data two"
                    ,
                        token: "test non-statement three"
                        misc: "test misc data three"
                ]
                next: [
                        token: "test statement b"
                        misc: "test misc data four"
                    ,
                        token: "test non-statement five"
                        misc: "test misc data five"
                    ,
                        token: "test non-statement six"
                        misc: "test misc data six"
                    ,
                        token: "test statement c"
                        misc: "test misc data seven"
                ]