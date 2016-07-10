describe "expression", -> describe "unroll", -> describe "concatenators", ->
    expressionUnrollConcatenators = require "./concatenators"

    map = (primitive, func) -> it "maps \"#{primitive}\" to \"#{func}\"", ->
        (expect expressionUnrollConcatenators[primitive]).toEqual func
    
    map "boolean", "concatenateBoolean"
    map "integer", "concatenateInteger"
    map "float", "concatenateFloat"