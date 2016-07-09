# When the typed title of the program changes, update the window title to
# match.

module.exports = editorSetupTitle = ->
    title = document.getElementById "Title"
    callback = -> 
        document.title = "#{title.value.trim() or "(untitled program)"} - Editor - SUNRUSE.influx"
    callback() # The title is lost when navigating to another page and back.
    title.addEventListener "change", callback
    title.addEventListener "input", callback