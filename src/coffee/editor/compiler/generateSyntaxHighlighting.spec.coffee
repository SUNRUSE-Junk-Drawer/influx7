describe "editor", -> describe "compiler", -> describe "generateSyntaxHighlighting", ->
    describe "on calling", ->
        editorCompilerGenerateSyntaxHighlighting = require "./generateSyntaxHighlighting"
    
        run = (config) -> describe config.description, ->
            result = tokensCopy = undefined
            beforeEach ->
                tokensCopy = JSON.parse JSON.stringify config.tokens
                result = editorCompilerGenerateSyntaxHighlighting config.code, tokensCopy
            it "does not modify the tokens", -> (expect tokensCopy).toEqual config.tokens
            it "returns the expected output", -> (expect result).toEqual config.output
    
        run
            description: "one token from start to end"
            code: "test code"
            tokens: [
                starts: 0
                ends: 8
                class: "test class a"
            ]
            output: [
                class: "test class a"
                code: "test code"
            ]
            
        run
            description: "one token after start to end"
            code: "test code"
            tokens: [
                starts: 2
                ends: 8
                class: "test class a"
            ]
            output: [
                    class: "Comment"
                    code: "te"
                ,
                    class: "test class a"
                    code: "st code"
            ]
            
        run
            description: "one token from start to before end"
            code: "test code"
            tokens: [
                starts: 0
                ends: 6
                class: "test class a"
            ]
            output: [
                    class: "test class a"
                    code: "test co"
                ,
                    class: "Comment"
                    code: "de"
            ]
            
        run
            description: "one token from start to before end"
            code: "test code"
            tokens: [
                starts: 3
                ends: 6
                class: "test class a"
            ]
            output: [
                    class: "Comment"
                    code: "tes"
                ,
                    class: "test class a"
                    code: "t co"
                ,
                    class: "Comment"
                    code: "de"
            ]
            
        run
            description: "two tokens occupying all space in order"
            code: "test code"
            tokens: [
                    starts: 0
                    ends: 2
                    class: "test class a"
                ,
                    starts: 3
                    ends: 8
                    class: "test class b"
            ]
            output: [
                    class: "test class a"
                    code: "tes"
                ,
                    class: "test class b"
                    code: "t code"
            ]
            
        run
            description: "two tokens occupying all space out of order"
            code: "test code"
            tokens: [
                    starts: 3
                    ends: 8
                    class: "test class b"
                ,
                    starts: 0
                    ends: 2
                    class: "test class a"
            ]
            output: [
                    class: "test class a"
                    code: "tes"
                ,
                    class: "test class b"
                    code: "t code"
            ]
            
        run
            description: "two tokens with a space before in order"
            code: "test code"
            tokens: [
                    starts: 2
                    ends: 5
                    class: "test class a"
                ,
                    starts: 6
                    ends: 8
                    class: "test class b"
            ]
            output: [
                    class: "Comment"
                    code: "te"
                ,
                    class: "test class a"
                    code: "st c"
                ,
                    class: "test class b"
                    code: "ode"
            ]
            
        run
            description: "two tokens with a space before out of order"
            code: "test code"
            tokens: [
                    starts: 6
                    ends: 8
                    class: "test class b"
                ,
                    starts: 2
                    ends: 5
                    class: "test class a"
            ]
            output: [
                    class: "Comment"
                    code: "te"
                ,
                    class: "test class a"
                    code: "st c"
                ,
                    class: "test class b"
                    code: "ode"
            ]
            
        run
            description: "two tokens with a space after in order"
            code: "test code"
            tokens: [
                    starts: 0
                    ends: 1
                    class: "test class a"
                ,
                    starts: 2
                    ends: 6
                    class: "test class b"
            ]
            output: [
                    class: "test class a"
                    code: "te"
                ,
                    class: "test class b"
                    code: "st co"
                ,
                    class: "Comment"
                    code: "de"
            ]
            
        run
            description: "two tokens with a space after out of order"
            code: "test code"
            tokens: [
                    starts: 2
                    ends: 6
                    class: "test class b"
                ,
                    starts: 0
                    ends: 1
                    class: "test class a"
            ]
            output: [
                    class: "test class a"
                    code: "te"
                ,
                    class: "test class b"
                    code: "st co"
                ,
                    class: "Comment"
                    code: "de"
            ]
            
        run
            description: "two tokens separated by a space in order"
            code: "test code"
            tokens: [
                    starts: 0
                    ends: 1
                    class: "test class a"
                ,
                    starts: 6
                    ends: 8
                    class: "test class b"
            ]
            output: [
                    class: "test class a"
                    code: "te"
                ,
                    class: "Comment"
                    code: "st c"
                ,
                    class: "test class b"
                    code: "ode"
            ]
            
        run
            description: "two tokens separated by a space space out of order"
            code: "test code"
            tokens: [
                    starts: 6
                    ends: 8
                    class: "test class b"
                ,
                    starts: 0
                    ends: 1
                    class: "test class a"
            ]
            output: [
                    class: "test class a"
                    code: "te"
                ,
                    class: "Comment"
                    code: "st c"
                ,
                    class: "test class b"
                    code: "ode"
            ]

        run
            description: "two tokens separated by a space with a space before in order"
            code: "test code"
            tokens: [
                    starts: 2
                    ends: 5
                    class: "test class a"
                ,
                    starts: 7
                    ends: 8
                    class: "test class b"
            ]
            output: [
                    class: "Comment"
                    code: "te"
                ,
                    class: "test class a"
                    code: "st c"
                ,
                    class: "Comment"
                    code: "o"
                ,
                    class: "test class b"
                    code: "de"
            ]
            
        run
            description: "two tokens separated by a space with a space before out of order"
            code: "test code"
            tokens: [
                    starts: 7
                    ends: 8
                    class: "test class b"
                ,
                    starts: 2
                    ends: 5
                    class: "test class a"
            ]
            output: [
                    class: "Comment"
                    code: "te"
                ,
                    class: "test class a"
                    code: "st c"
                ,
                    class: "Comment"
                    code: "o"
                ,
                    class: "test class b"
                    code: "de"
            ]
            
        run
            description: "two tokens separated by a space with a space after in order"
            code: "test code"
            tokens: [
                    starts: 0
                    ends: 1
                    class: "test class a"
                ,
                    starts: 6
                    ends: 7
                    class: "test class b"
            ]
            output: [
                    class: "test class a"
                    code: "te"
                ,
                    class: "Comment"
                    code: "st c"
                ,
                    class: "test class b"
                    code: "od"
                ,
                    class: "Comment"
                    code: "e"
            ]
            
        run
            description: "two tokens separated by a space with a space after out of order"
            code: "test code"
            tokens: [
                    starts: 6
                    ends: 7
                    class: "test class b"
                ,   
                    starts: 0
                    ends: 1
                    class: "test class a"
            ]
            output: [
                    class: "test class a"
                    code: "te"
                ,
                    class: "Comment"
                    code: "st c"
                ,
                    class: "test class b"
                    code: "od"
                ,
                    class: "Comment"
                    code: "e"
            ]
            
        run
            description: "complex scenario"
            code: "  this is  test code to be split up by the  code under test "
            tokens: [
                    starts: 19
                    ends: 26
                    class: "test class d"
                ,
                    starts: 0
                    ends: 4
                    class: "test class a"
                ,   
                    starts: 7
                    ends: 12
                    class: "test class b"
                ,
                    starts: 13
                    ends: 18
                    class: "test class c"
                ,
                    starts: 32
                    ends: 48
                    class: "test class e"
            ]
            output: [
                    code: "  thi"
                    class: "test class a"
                ,   
                    code: "s "
                    class: "Comment"
                ,   
                    code: "is  te"
                    class: "test class b"
                ,
                    code: "st cod"
                    class: "test class c"
                ,
                    code: "e to be "
                    class: "test class d"
                ,   
                    code: "split"
                    class: "Comment"
                ,
                    code: " up by the  code "
                    class: "test class e"
                ,   
                    code: "under test "
                    class: "Comment"
            ]