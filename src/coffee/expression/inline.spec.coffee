describe "expression", -> describe "inline", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionInline = rewire "./inline"
        it "itself", -> (expect expressionInline.__get__ "recurse").toBe expressionInline
    describe "on calling", ->
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