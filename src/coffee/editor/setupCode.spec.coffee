describe "editor", -> describe "setupCode", ->
    rewire = require "rewire"
    describe "imports", ->
        editorSetupCode = rewire "./setupCode"
        it "editorThrottleCompilation", -> (expect editorSetupCode.__get__ "editorThrottleCompilation").toBe require "./throttleCompilation"
    describe "on calling", ->
        editorSetupCode = rewire "./setupCode"
        editorThrottleCompilation = element = document = undefined
        beforeEach ->
            element = 
                addEventListener: jasmine.createSpy "addEventListener"
            document = 
                getElementById: (id) ->
                    (expect id).toEqual "Code"
                    element
            editorSetupCode.__set__ "document", document
            
            editorThrottleCompilation = jasmine.createSpy "editorThrottleCompilation"
            editorSetupCode.__set__ "editorThrottleCompilation", editorThrottleCompilation
            
            editorSetupCode()
                        
        it "calls editorSetupCode once", ->
            (expect editorThrottleCompilation.calls.count()).toEqual 1
        it "adds two event listeners to the code element", ->
            (expect element.addEventListener.calls.count()).toEqual 2
        it "adds an event listener for the code element receiving input", ->
            (expect element.addEventListener).toHaveBeenCalledWith "input", jasmine.any Function
        it "adds an event listener for the code element's value changing", ->
            (expect element.addEventListener).toHaveBeenCalledWith "change", jasmine.any Function
            
        sharedEventTests = (description, before) ->
            describe description, ->
                beforeEach ->
                    before()
                it "calls editorSetupCode once again", ->
                    (expect editorThrottleCompilation.calls.count()).toEqual 2
                it "does not add any further event listeners to the code element", ->
                    (expect element.addEventListener.calls.count()).toEqual 2
            
        sharedEventTests "on calling the first event listener", -> (element.addEventListener.calls.argsFor 0)[1]()
        sharedEventTests "on calling the second event listener", -> (element.addEventListener.calls.argsFor 1)[1]()