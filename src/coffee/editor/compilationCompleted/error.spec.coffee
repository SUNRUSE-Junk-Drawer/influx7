describe "editor", -> describe "compilationCompleted", -> describe "error", ->
    rewire = require "rewire"
    describe "imports", ->
        editorCompilationCompletedError = rewire "./error"
        it "editorCompilationCompletedErrorLocalizations", -> (expect editorCompilationCompletedError.__get__ "editorCompilationCompletedErrorLocalizations").toBe require "./error/localizations"
    describe "on calling", ->
        editorCompilationCompletedError = document = beforeElement = highlightElement = errorElement = detailsElement = messageElement = editorCompilationCompletedErrorLocalizations = undefined
        editorCompilationCompletedErrorLocalizationsCopy = 
            testErrorA:
                message: "test error message a"
                details: "test error details a"
            testErrorB:
                message: "test error message b"
                details: "test error details b"
            testErrorC:
                message: "test error message c"
                details: "test error details c"
        beforeEach -> 
            editorCompilationCompletedError = rewire "./error"
            document = 
                getElementById: (id) ->
                    (expect id).toEqual "Error"
                    errorElement
            errorElement = 
                style:
                    display: "none"
                    misc: "unmodified"
                getElementsByClassName: (className) -> switch className
                    when "Message" then [messageElement]
                    when "Details" then [detailsElement]
                    when "Before" then [beforeElement]
                    when "Highlight" then [highlightElement]
                    else fail "unexpected call to getElementsByClassName for className #{className}"
            messageElement = 
                textContent: "existing message textContent"
            detailsElement = 
                textContent: "existing details textContent"
            beforeElement = 
                textContent: "existing before textContent"
            highlightElement = 
                textContent: "existing highlight textContent"
            editorCompilationCompletedError.__set__ "document", document
            editorCompilationCompletedError.__set__ "editorCompilationCompletedErrorLocalizations", editorCompilationCompletedErrorLocalizations = JSON.parse JSON.stringify editorCompilationCompletedErrorLocalizationsCopy
            
        describe "without an error", ->
            event = eventCopy = undefined
            beforeEach ->
                event = 
                    misc: "unmodified"
                    data:
                        misc: "unmodified"
                eventCopy = JSON.parse JSON.stringify event
                editorCompilationCompletedError event
                
            it "does not change the error's \"display\" style", -> (expect errorElement.style.display).toEqual "none"
            it "does not change other aspects of the error's style", -> (expect errorElement.style.misc).toEqual "unmodified"
            it "does not modify editorCompilationCompletedErrorLocalizations", -> (expect editorCompilationCompletedErrorLocalizations).toEqual editorCompilationCompletedErrorLocalizationsCopy
            it "does not modify the event", -> (expect event).toEqual eventCopy
        describe "with an error", ->
            event = eventCopy = undefined
            beforeEach ->
                event = 
                    misc: "unmodified"
                    data:
                        misc: "unmodified"
                        error:
                            reason: "testErrorB"
                            before: "test before text"
                            highlight: "test highlight text"
                    
                eventCopy = JSON.parse JSON.stringify event
                editorCompilationCompletedError event
        
            it "changes the error's \"display\" style to \"block\"", -> (expect errorElement.style.display).toEqual "block"
            it "does not change other aspects of the error's style", -> (expect errorElement.style.misc).toEqual "unmodified"
            it "changes the error's message text content", -> (expect messageElement.textContent).toEqual "test error message b"
            it "changes the error's details text content", -> (expect detailsElement.textContent).toEqual "test error details b"
            it "changes the error's before text content", -> (expect beforeElement.textContent).toEqual "test before text"
            it "changes the error's highlight text content", -> (expect highlightElement.textContent).toEqual "test highlight text"
            it "does not modify editorCompilationCompletedErrorLocalizations", -> (expect editorCompilationCompletedErrorLocalizations).toEqual editorCompilationCompletedErrorLocalizationsCopy
            it "does not modify the event", -> (expect event).toEqual eventCopy