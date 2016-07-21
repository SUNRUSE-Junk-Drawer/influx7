# Part of the "message" event handler for the compiler Worker.
# Generates and appends syntax highlighting elements.
module.exports = editorCompilationCompletedSyntaxHighlighting = (e) ->
    syntaxHighlighting = document.getElementById "SyntaxHighlighting"
    for run in e.data.syntaxHighlighting
        element = document.createElement "SPAN"
        element.textContent = run.code
        element.className = run.class
        syntaxHighlighting.appendChild element