# When the code of the program changes, calls editorCompileCode with the new
# source code.

module.exports = editorSetupCode = ->
    code = document.getElementById "Code"
    callback = -> editorThrottleCompilation()
    callback()
    code.addEventListener "change", callback
    code.addEventListener "input", callback
    
editorThrottleCompilation = require "./throttleCompilation"