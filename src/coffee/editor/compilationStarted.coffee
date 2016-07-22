# Called whenever the code changes, to remove all syntax highlighting and the
# error message.  These will be replaced on compilation success.
module.exports = editorCompilationStarted = ->

    syntaxHighlighting = document.getElementById "SyntaxHighlighting"
    while syntaxHighlighting.lastChild
        syntaxHighlighting.removeChild syntaxHighlighting.lastChild
        
    (document.getElementById "Error").style.display = "none"