describe "expression", -> describe "inline", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionInline = rewire "./inline"
        it "itself", -> (expect expressionInline.__get__ "recurse").toBe expressionInline
    describe "unit", ->
        expressionInline = rewire "./inline"
        declarations = 
            textExistingDeclarationA: "test declaration value a"
            textExistingDeclarationB: "test declaration value b"
        run = (config) -> describe config.description, ->
            recursesToCopy = inputCopy = declarationsCopy = undefined
            beforeEach ->
                recursesToCopy = JSON.parse JSON.stringify config.recursesTo or null
                inputCopy = JSON.parse JSON.stringify config.input
                declarationsCopy = JSON.parse JSON.stringify declarations
                expressionInline.__set__ "recurse", (expr, decl) ->
                    if recursesToCopy
                        match = recursesToCopy[expr]
                        if match
                            (expect decl).toEqual match.declarations
                            return match.output
                    fail "unexpected recursion with #{expr}, #{decl}"
            if config.throws
                it "throws the expected object", -> (expect -> expressionInline inputCopy, declarationsCopy).toThrow config.throws
            else
                it "returns the expected object", -> (expect expressionInline inputCopy, declarationsCopy).toEqual config.output
            describe "then", ->
                beforeEach ->
                    try
                        expressionInline inputCopy, declarationsCopy
                    catch ex
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
                it "does not modify the declarations", -> (expect declarationsCopy).toEqual declarations
                it "does not modify any recursed objects", -> (expect recursesToCopy).toEqual config.recursesTo or null
                
        run
            description: "falsy primitive"
            input:
                primitive: "test primitive"
                value: null
                starts: 37
                ends: 65
            output:
                primitive: "test primitive"
                value: null
                starts: 37
                ends: 65
                
        run
            description: "truthy primitive"
            input:
                primitive: "test primitive"
                value: "test value"
                starts: 37
                ends: 65
            output:
                primitive: "test primitive"
                value: "test value"
                starts: 37
                ends: 65
                
        run
            description: "native function call"
            input:
                call: "test function"
                with: ["test argument a", "test argument b", "test argument c"]
                starts: 37
                ends: 65
            recursesTo:
                "test argument a":
                    declarations:
                        textExistingDeclarationA: "test declaration value a"
                        textExistingDeclarationB: "test declaration value b"
                    output: "test recursed argument a"
                "test argument b":
                    declarations:
                        textExistingDeclarationA: "test declaration value a"
                        textExistingDeclarationB: "test declaration value b"
                    output: "test recursed argument b"
                "test argument c":
                    declarations:
                        textExistingDeclarationA: "test declaration value a"
                        textExistingDeclarationB: "test declaration value b"
                    output: "test recursed argument c"
            output:
                call: "test function"
                with: ["test recursed argument a", "test recursed argument b", "test recursed argument c"]
                starts: 37
                ends: 65            
                
        run
            description: "let statement where the name is unique"
            input:
                let:
                    token: "test let token"
                    starts: 37
                    ends: 65
                declare:
                    token: "testNonexistentDeclaration"
                    starts: 108
                    ends: 134
                as: "test new declaration"
                then: "test expression"
            recursesTo:
                "test expression":
                    declarations:
                        textExistingDeclarationA: "test declaration value a"
                        textExistingDeclarationB: "test declaration value b"
                        testNonexistentDeclaration: "test recursed new declaration"
                    output: "test recursed expression"
                "test new declaration":
                    declarations:
                        textExistingDeclarationA: "test declaration value a"
                        textExistingDeclarationB: "test declaration value b"
                    output: "test recursed new declaration"
            output: "test recursed expression"
            
        run
            description: "let statement where the name is not unique"
            input:
                let:
                    token: "test let token"
                    starts: 37
                    ends: 65
                declare:
                    token: "textExistingDeclarationA"
                    starts: 108
                    ends: 134
                as: "test new declaration"
                then: "test expression"
            throws:
                reason: "identifierNotUnique"
                starts: 108
                ends: 134
            
        run
            description: "return statement"
            input:
                return: "test expression"
                starts: 37
                ends: 108
            recursesTo:
                "test expression":
                    declarations: declarations
                    output: "test recursed expression"
            output: "test recursed expression"
            
        run
            description: "parentheses statement"
            input:
                parentheses: "test expression"
                starts: 37
                ends: 108
            recursesTo:
                "test expression":
                    declarations: declarations
                    output: "test recursed expression"
            output: "test recursed expression"
            
        run
            description: "valid reference"
            input:
                reference: "textExistingDeclarationB"
                starts: 37
                ends: 108
            output: "test declaration value b"
            
        run
            description: "invalid reference"
            input:
                reference: "testNonexistentDeclaration"
                starts: 37
                ends: 108
            throws:
                reason: "undefinedReference"
                starts: 37
                ends: 108
                
    describe "integration", ->
        tokenize = require "./../tokenize"
        expressionParse = require "./parse"
        expressionInline = require "./inline"
    
        run = (config) -> describe config.description, ->
            it "returns the expected result", ->
                try
                    (expect expressionInline (expressionParse tokenize config.input), {}).toEqual config.output
                catch ex
                    if ex.reason
                        fail JSON.stringify ex, null, 4
                    else throw ex
            
        run 
            description: "basic let"
            input:  """
                let a 3 + 4
                let b 8 - 9
                return a * b
                    """
            output: 
                call: "multiply"
                starts: 33
                ends: 33
                with: [
                        call: "add"
                        starts: 8
                        ends: 8
                        with: [
                                primitive: "integer"
                                value: 3
                                starts: 6
                                ends: 6
                            ,
                                primitive: "integer"
                                value: 4
                                starts: 10
                                ends: 10
                        ]
                    ,
                        call: "subtract"
                        starts: 20
                        ends: 20
                        with: [
                                primitive: "integer"
                                value: 8
                                starts: 18
                                ends: 18
                            ,
                                primitive: "integer"
                                value: 9
                                starts: 22
                                ends: 22
                        ]
                ]
                
        run 
            description: "reuse of let"
            input:  """
                let a 3 + 4
                let b 8 - a
                return a * b
                    """
            output: 
                call: "multiply"
                starts: 33
                ends: 33
                with: [
                        call: "add"
                        starts: 8
                        ends: 8
                        with: [
                                primitive: "integer"
                                value: 3
                                starts: 6
                                ends: 6
                            ,
                                primitive: "integer"
                                value: 4
                                starts: 10
                                ends: 10
                        ]
                    ,
                        call: "subtract"
                        starts: 20
                        ends: 20
                        with: [
                                primitive: "integer"
                                value: 8
                                starts: 18
                                ends: 18
                            ,
                                call: "add"
                                starts: 8
                                ends: 8
                                with: [
                                        primitive: "integer"
                                        value: 3
                                        starts: 6
                                        ends: 6
                                    ,
                                        primitive: "integer"
                                        value: 4
                                        starts: 10
                                        ends: 10
                                ]
                        ]
                ]
                
        run 
            description: "scoped let"
            input:  """
                (
                    let a 3 + 10
                    let b 7 - 8
                    return a * -b
                ) + (
                    let a 7 - 4
                    let b 5 * 4
                    return b * a
                )
                    """
            output: 
                call: "add"
                starts: 55
                ends: 55
                with: [
                        # First scope
                        call: "multiply"
                        starts: 48
                        ends: 48
                        with: [
                                # a
                                call: "add"
                                starts: 14
                                ends: 14
                                with: [
                                        primitive: "integer"
                                        value: 3
                                        starts: 12
                                        ends: 12
                                    ,
                                        primitive: "integer"
                                        value: 10
                                        starts: 16
                                        ends: 17
                                ]
                            ,
                                call: "negate"
                                starts: 50
                                ends: 50
                                with: [
                                    # b
                                    call: "subtract"
                                    starts: 31
                                    ends: 31
                                    with: [
                                            primitive: "integer"
                                            value: 7
                                            starts: 29
                                            ends: 29
                                        ,
                                            primitive: "integer"
                                            value: 8
                                            starts: 33
                                            ends: 33
                                    ]
                                ]
                        ]
                    ,
                       # Second scope
                        call: "multiply"
                        starts: 104
                        ends: 104
                        with: [
                                # b
                                call: "multiply"
                                starts: 87
                                ends: 87
                                with: [
                                        primitive: "integer"
                                        value: 5
                                        starts: 85
                                        ends: 85
                                    ,
                                        primitive: "integer"
                                        value: 4
                                        starts: 89
                                        ends: 89
                                ]
                            ,
                                # a
                                call: "subtract"
                                starts: 71
                                ends: 71
                                with: [
                                        primitive: "integer"
                                        value: 7
                                        starts: 69
                                        ends: 69
                                    ,
                                        primitive: "integer"
                                        value: 4
                                        starts: 73
                                        ends: 73
                                ]
                        ]
                ]