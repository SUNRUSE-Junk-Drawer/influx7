describe "editor", -> describe "compilationCompleted", -> describe "syntaxHighlighting", ->
    rewire = require "rewire"
    describe "on calling", ->
        editorCompilationCompletedSyntaxHighlighting = rewire "./syntaxHighlighting"
        event = eventCopy = elements = element = document = undefined
        beforeEach ->
            elements = []
            element = 
                appendChild: jasmine.createSpy "appendChild"
            document = 
                getElementById: (id) ->
                    (expect id).toEqual "SyntaxHighlighting"
                    element
                createElement: (tagName) ->
                    (expect tagName).toEqual 
                    output = 
                        className: ""
                        textContent: ""
                    elements.push output
                    output
            editorCompilationCompletedSyntaxHighlighting.__set__ "document", document
            event =
                misc: "unmodified"
                data:
                    misc: "unmodified"
                    syntaxHighlighting: [
                            code: "test code a"
                            class: "test class a"
                        ,
                            code: "test code b"
                            class: "test class b"
                        ,
                            code: "test code c"
                            class: "test class c"
                    ]
            eventCopy = JSON.parse JSON.stringify event
            editorCompilationCompletedSyntaxHighlighting eventCopy
        it "does not modify the input", -> (expect eventCopy).toEqual event
        it "creates a single element for each run", -> (expect elements.length).toEqual 3
        it "populates the elements' \"textContent\" properties", ->
            (expect elements[0].textContent).toEqual "test code a"
            (expect elements[1].textContent).toEqual "test code b"
            (expect elements[2].textContent).toEqual "test code c"
        it "populates the elements' \"className\" properties", ->
            (expect elements[0].className).toEqual "test class a"
            (expect elements[1].className).toEqual "test class b"
            (expect elements[2].className).toEqual "test class c"
        it "adds each element to the \"SyntaxHighlighting\" element in order", ->
            (expect element.appendChild.calls.allArgs()).toEqual [[elements[0]], [elements[1]], [elements[2]]]