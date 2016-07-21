# Part of the "message" event handler for the compiler Worker.
# Updates the error elements should an error have occurred.
module.exports = editorCompilationCompletedError = (e) ->
    if e.data.error
        error = document.getElementById "Error"
        error.style.display = "block"
        localization = editorCompilationCompletedErrorLocalizations[e.data.error.reason]
        (error.getElementsByClassName "Message")[0].textContent = localization.message
        (error.getElementsByClassName "Details")[0].textContent = localization.details
        (error.getElementsByClassName "Before")[0].textContent = e.data.error.before
        (error.getElementsByClassName "Highlight")[0].textContent = e.data.error.highlight

editorCompilationCompletedErrorLocalizations = require "./error/localizations"