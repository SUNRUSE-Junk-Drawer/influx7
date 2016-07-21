describe "editor", -> describe "compilationCompleted", ->
    rewire = require "rewire"
    describe "imports", ->
        editorCompilationCompleted = rewire "./compilationCompleted"
        it "editorCompilationCompletedSyntaxHighlighting", -> (expect editorCompilationCompleted.__get__ "editorCompilationCompletedSyntaxHighlighting").toBe require "./compilationCompleted/syntaxHighlighting"
        it "editorCompilationCompletedError", -> (expect editorCompilationCompleted.__get__ "editorCompilationCompletedError").toBe require "./compilationCompleted/error"
    describe "on calling", ->
        editorCompilationCompletedError = editorCompilationCompletedSyntaxHighlighting = undefined
        editorCompilationCompleted = rewire "./compilationCompleted"
        beforeEach ->
            editorCompilationCompleted.__set__ "editorCompilationCompletedSyntaxHighlighting", editorCompilationCompletedSyntaxHighlighting = jasmine.createSpy "editorCompilationCompletedSyntaxHighlighting"
            editorCompilationCompleted.__set__ "editorCompilationCompletedError", editorCompilationCompletedError = jasmine.createSpy "editorCompilationCompletedError"
            editorCompilationCompleted "test event"
        it "calls editorCompilationCompletedSyntaxHighlighting once", -> (expect editorCompilationCompletedSyntaxHighlighting.calls.count()).toEqual 1
        it "calls editorCompilationCompletedSyntaxHighlighting with the event", -> (expect editorCompilationCompletedSyntaxHighlighting).toHaveBeenCalledWith "test event"
        it "calls editorCompilationCompletedError once", -> (expect editorCompilationCompletedError.calls.count()).toEqual 1
        it "calls editorCompilationCompletedError with the event", -> (expect editorCompilationCompletedError).toHaveBeenCalledWith "test event"