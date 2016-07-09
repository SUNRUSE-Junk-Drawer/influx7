describe "editor", -> describe "index", ->
    rewire = require "rewire"
    describe "imports", ->
        global.window = 
            addEventListener: jasmine.createSpy "addEventListener"
        editorIndex = rewire "./index"
        it "editorSetupTitle", -> (expect editorIndex.__get__ "editorSetupTitle").toBe require "./setupTitle"
    describe "on evaluating", ->
        editorSetupTitle = editorIndex = undefined
        beforeEach ->
            global.window = 
                addEventListener: jasmine.createSpy "addEventListener"
            editorIndex = rewire "./index"
            
            editorSetupTitle = jasmine.createSpy "editorSetupTitle"
            editorIndex.__set__ "editorSetupTitle", editorSetupTitle
        
        it "executes window.addEventListener once", ->
            (expect window.addEventListener.calls.count()).toEqual 1
            
        it "listens for the \"pageshow\" event", ->
            (expect window.addEventListener).toHaveBeenCalledWith "pageshow", jasmine.any Function
        
        it "does not yet call editorSetupTitle once", ->
            (expect editorSetupTitle).not.toHaveBeenCalled()
        
        describe "on loading the page", ->
            beforeEach -> (window.addEventListener.calls.argsFor 0)[1]()
                
            it "does not call window.addEventListener again", ->
                (expect window.addEventListener.calls.count()).toEqual 1
        
            it "calls editorSetupTitle once", ->
                (expect editorSetupTitle.calls.count()).toEqual 1