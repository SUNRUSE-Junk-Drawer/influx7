# Part of the "message" event handler for the compiler Worker.
# Puts the result of compilation on the screen.
module.exports = editorCompilationCompletedResult = (e) ->
    (document.getElementById "Result").textContent = e.data.result or ""