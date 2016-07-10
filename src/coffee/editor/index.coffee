window.addEventListener "pageshow", ->
    editorSetupTitle()
    editorSetupCode()
    
editorSetupTitle = require "./setupTitle"
editorSetupCode = require "./setupCode"