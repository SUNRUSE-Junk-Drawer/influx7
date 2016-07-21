# Exports a function.  Call this whenever the code changes.
# Will wait until 250msec have passed without a code change, then defer to 
# ./workerManager to process the changes.

timeout = null

module.exports = editorThrottleCompilation = ->
    editorWorkerManager.cancel()
        
    if timeout
        clearTimeout timeout
        timeout = null
    timeout = setTimeout ( ->
        timeout = null
        editorWorkerManager.start()
    ), 250
    
editorWorkerManager = require "./workerManager"