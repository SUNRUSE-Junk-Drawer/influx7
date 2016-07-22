describe "tokenize", -> describe "keywords", ->
    tokenizeKeywords = require "./keywords"
    
    describe "excludes", ->
        excludes = (character) ->
            it character, -> (expect tokenizeKeywords.indexOf character).toEqual -1
            
        excludes ":"
            
        describe "unary symbol", ->
            excludes "!"
            excludes "-"
            
        describe "binary symbol", ->
            excludes "+"
            excludes ">"
            excludes "!="
    
        describe "parenthesis", ->
            excludes "("
            excludes "["
            excludes ")"
            excludes "]"
            
        describe "deliminators", ->
            excludes ","
            excludes "."
            
        xdescribe "statement symbol", ->
            excludes "(a statement symbol)"
    
    describe "includes", ->
        includes = (character) ->
            it character, -> (expect tokenizeKeywords.indexOf character).not.toEqual -1
        
        describe "unary keyword", ->
            includes "not"
        
        describe "binary keyword", ->
            includes "and"
            includes "or"
            includes "is"
            
        describe "primitive literal", ->
            includes "false"
            includes "true"
            
        describe "statement keyword", ->
            includes "function"
        
        it "no duplicates", ->
            for character, index in tokenizeKeywords
                (expect tokenizeKeywords.indexOf character).toEqual index, character