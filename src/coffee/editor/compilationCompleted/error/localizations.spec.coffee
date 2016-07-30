describe "editor", -> describe "compilationCompleted", -> describe "error", -> describe "localizations", ->
    editorCompilationCompletedErrorLocalizations = require "./localizations"
    localizes = (key) -> describe key, ->
        it "defines \"message\"", -> (expect editorCompilationCompletedErrorLocalizations[key].message).toEqual jasmine.any String
        it "defines \"details\"", -> (expect editorCompilationCompletedErrorLocalizations[key].details).toEqual jasmine.any String
        
    localizes "typeCheckFailed"
    localizes "fileEmpty"
    localizes "unclosedParentheses"
    localizes "unopenedParentheses"
    localizes "invalidExpression"
    localizes "inconsistentPlurality"
    localizes "identifierInvalid"
    localizes "identifierNotUnique"
    localizes "emptyExpression"