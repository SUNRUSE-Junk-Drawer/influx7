# The "message" event handler for the compiler Worker.
module.exports = editorCompilationCompleted = (e) ->
    editorCompilationCompletedSyntaxHighlighting e
    editorCompilationCompletedError e
        
editorCompilationCompletedSyntaxHighlighting = require "./compilationCompleted/syntaxHighlighting"
editorCompilationCompletedError = require "./compilationCompleted/error"