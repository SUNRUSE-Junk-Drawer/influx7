describe "editor", -> describe "compilationCompleted", -> describe "result", ->
    rewire = require "rewire"
    describe "on calling", ->
        editorCompilationCompletedResult = rewire "./result"
        run = (config) -> describe config.description, ->
            event = eventCopy = elements = element = document = undefined
            beforeEach ->
                element = 
                    textContent: "test existing textContent"
                    misc: "unmodified"
                document = 
                    getElementById: (id) ->
                        (expect id).toEqual "Result"
                        element
                editorCompilationCompletedResult.__set__ "document", document
                event =
                    misc: "unmodified"
                    data: config.data
                eventCopy = JSON.parse JSON.stringify event
                editorCompilationCompletedResult eventCopy
            
            it "does not modify the input", -> (expect eventCopy).toEqual event
            it "sets \"textContent\" to the expected value", -> (expect element.textContent).toEqual config.textContent
            it "does not modify other aspects of the element", -> (expect element.misc).toEqual "unmodified"
    
        run
            description: "without a result"
            data:
                misc: "unmodified from data"
            textContent: ""
            
        run
            description: "with a result"
            data:
                misc: "unmodified from data"
                result: "test result"
            textContent: "test result"