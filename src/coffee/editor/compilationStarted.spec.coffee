describe "editor", -> describe "compilationStarted", ->
    rewire = require "rewire"
    describe "on calling", ->
        document = syntaxHighlightingElement = errorElement = undefined
        beforeEach ->
            editorCompilationStarted = rewire "./compilationStarted"
            syntaxHighlightingElement = 
                lastChild: "test child c"
                removeChild: jasmine.createSpy "syntaxHighlightingElement.removeChild"
            syntaxHighlightingElement.removeChild.and.callFake (child) -> switch child
                when "test child c"
                    (expect syntaxHighlightingElement.lastChild).toEqual "test child c"
                    syntaxHighlightingElement.lastChild = "test child b"
                when "test child b"
                    (expect syntaxHighlightingElement.lastChild).toEqual "test child b"
                    syntaxHighlightingElement.lastChild = "test child a"
                when "test child a"
                    (expect syntaxHighlightingElement.lastChild).toEqual "test child a"
                    syntaxHighlightingElement.lastChild = null
                else "unexpected removal of child #{child}"
            errorElement = 
                style:
                    misc: "unmodified"
                    display: "block"
            editorCompilationStarted.__set__ "document",
                getElementById: (id) -> switch id
                    when "Error" then errorElement
                    when "SyntaxHighlighting" then syntaxHighlightingElement
                    else fail "Unexpected query for element with id #{id}"
            editorCompilationStarted()
        it "removes every syntax highlighting run", ->
            (expect syntaxHighlightingElement.removeChild.calls.allArgs()).toEqual [["test child c"], ["test child b"], ["test child a"]]
        it "hides the error message", ->
            (expect errorElement.style.display).toEqual "none"
        it "does not modify other aspects of the error message's style", ->
            (expect errorElement.style.misc).toEqual "unmodified"