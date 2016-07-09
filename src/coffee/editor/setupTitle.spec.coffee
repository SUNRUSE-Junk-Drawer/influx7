describe "editor", -> describe "setupTitle", ->
    rewire = require "rewire"
    describe "on calling", ->
        editorSetupTitle = rewire "./setupTitle"
        element = document = undefined
        beforeEach ->
            element = 
                addEventListener: jasmine.createSpy "addEventListener"
            document = 
                title: "test existing title"
                getElementById: (id) ->
                    (expect id).toEqual "Title"
                    element
            editorSetupTitle.__set__ "document", document
                        
        sharedInitialTests = ->
            it "adds two event listeners to the title element", ->
                (expect element.addEventListener.calls.count()).toEqual 2
            it "adds an event listener for the title element receiving input", ->
                (expect element.addEventListener).toHaveBeenCalledWith "input", jasmine.any Function
            it "adds an event listener for the title element's value changing", ->
                (expect element.addEventListener).toHaveBeenCalledWith "change", jasmine.any Function
            sharedEventTests "on calling the first event listener", -> (element.addEventListener.calls.argsFor 0)[1]()
            sharedEventTests "on calling the second event listener", -> (element.addEventListener.calls.argsFor 1)[1]()
            
        sharedEventTests = (description, callback) ->
            forChangeTo description, callback, "empty", "", "(untitled program) - Editor - SUNRUSE.influx"
            forChangeTo description, callback, "whitespace", "   \t \n   \r  \n  ", "(untitled program) - Editor - SUNRUSE.influx"
            forChangeTo description, callback, "a valid title", "this is another valid title", "this is another valid title - Editor - SUNRUSE.influx"
            forChangeTo description, callback, "a valid title with preceding whitespace", "    this is another valid title", "this is another valid title - Editor - SUNRUSE.influx"
            forChangeTo description, callback, "a valid title with trailing whitespace", "this is another valid title   ", "this is another valid title - Editor - SUNRUSE.influx"
                        
        forChangeTo = (description, callback, titleDescription, codeTitle, pageTitle) ->
            describe "on changing the page title to #{titleDescription}", ->
                beforeEach ->
                    element.value = codeTitle
                    callback()
                it "does not add further event listeners to the title element", ->
                    (expect element.addEventListener.calls.count()).toEqual 2
                        
        describe "when the title is empty", ->
            beforeEach ->
                element.value = ""
                editorSetupTitle()
            it "sets the document's title", ->
                (expect document.title).toEqual "(untitled program) - Editor - SUNRUSE.influx"
            sharedInitialTests()
                
        describe "when the title is whitespace", ->
            beforeEach ->
                element.value = "   \n    \r   \n  \t   "
                editorSetupTitle()
            it "sets the document's title", ->
                (expect document.title).toEqual "(untitled program) - Editor - SUNRUSE.influx"
            sharedInitialTests()
                
        describe "when the title is valid", ->
            beforeEach ->
                element.value = "this is a  valid title for a program"
                editorSetupTitle()
            it "sets the document's title", ->
                (expect document.title).toEqual "this is a  valid title for a program - Editor - SUNRUSE.influx"
            sharedInitialTests()
            
        describe "when the title is valid with preceding whitespace", ->
            beforeEach ->
                element.value = "     this is a  valid title for a program"
                editorSetupTitle()
            it "sets the document's title", ->
                (expect document.title).toEqual "this is a  valid title for a program - Editor - SUNRUSE.influx"
            sharedInitialTests()
            
        describe "when the title is valid with trailing whitespace", ->
            beforeEach ->
                element.value = "this is a  valid title for a program    "
                editorSetupTitle()
            it "sets the document's title", ->
                (expect document.title).toEqual "this is a  valid title for a program - Editor - SUNRUSE.influx"
            sharedInitialTests()