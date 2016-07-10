describe "editor", -> describe "index", ->
    rewire = require "rewire"
    describe "imports", ->
        global.window = 
            addEventListener: jasmine.createSpy "addEventListener"
        editorIndex = rewire "./index"
        it "editorSetupTitle", -> (expect editorIndex.__get__ "editorSetupTitle").toBe require "./setupTitle"
        it "editorSetupCode", -> (expect editorIndex.__get__ "editorSetupCode").toBe require "./setupCode"
    describe "on evaluating", ->
        editorSetupTitle = editorSetupCode = editorIndex = undefined
        beforeEach ->
            global.window = 
                addEventListener: jasmine.createSpy "addEventListener"
            editorIndex = rewire "./index"
            
            editorSetupTitle = jasmine.createSpy "editorSetupTitle"
            editorIndex.__set__ "editorSetupTitle", editorSetupTitle

            editorSetupCode = jasmine.createSpy "editorSetupCode"
            editorIndex.__set__ "editorSetupCode", editorSetupCode
            
        it "executes window.addEventListener once", ->
            (expect window.addEventListener.calls.count()).toEqual 1
            
        it "listens for the \"pageshow\" event", ->
            (expect window.addEventListener).toHaveBeenCalledWith "pageshow", jasmine.any Function
        
        it "does not yet call editorSetupTitle", ->
            (expect editorSetupTitle).not.toHaveBeenCalled()

        it "does not yet call editorSetupCode", ->
            (expect editorSetupCode).not.toHaveBeenCalled()
            
        describe "on loading the page", ->
            beforeEach -> (window.addEventListener.calls.argsFor 0)[1]()
                
            it "does not call window.addEventListener again", ->
                (expect window.addEventListener.calls.count()).toEqual 1
        
            it "calls editorSetupTitle once", ->
                (expect editorSetupTitle.calls.count()).toEqual 1
                
            it "calls editorSetupCode once", ->
                (expect editorSetupCode.calls.count()).toEqual 1