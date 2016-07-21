# Exports an object with two methods:
# - cancel: Call when source code should not be processed.
# - start: Call when the source code should be processed and a background worker
#          will be started.  Expects to be preceded by at least one call to 
#          cancel.  (without a call to start between)
# Uses the global variable "compilerUrl" when starting a worker.

running = null

module.exports = editorWorkerManager =
    start: ->
        running = new Worker compilerUrl
        running.postMessage (document.getElementById "Code").value
        running.addEventListener "message", (e) ->
            running = null
            editorCompilationCompleted e
        running.addEventListener "error", (e) ->
            running = null
            editorCompilationFailed e
    cancel: ->
        if running
            running.terminate()
            running = null
        editorCompilationStarted()
    
editorCompilationCompleted = require "./compilationCompleted"
editorCompilationFailed = require "./compilationFailed"
editorCompilationStarted = require "./compilationStarted"