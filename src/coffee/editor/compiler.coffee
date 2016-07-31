# This is a standalone Webpack bundled executed as a worker to compile the code
# which is passed in as the data of the message posted to it.
# On success or failure, it will post a single message back, containing:
# - syntaxHighlighting: An array of run objects.
# - error: An object which is only present when an error has occurred,
#          containing:
#   + reason: A string identifying the problem.
#   + before: A string containing the source code preceding the error.
#   + highlight: A string containing the source code which caused the error.
# This is currently work-in-progress and will change significantly when
# statement parsing is introduced; for the future, it should be broken down into
# a module for each stage and unit tests introduced.

addEventListener "message", (e) ->
        
    tokens = []
    (tokens = tokens.concat tokenizeSplitToken token) for token in tokenizeSplitByWhitespace e.data
    
    if not tokens.length
        postMessage
            error:
                reason: "fileEmpty"
                before: ""
                highlight: e.data
            syntaxHighlighting: []
        close()
        return
        
    parenthesized = undefined
        
    try
        parenthesized = tokenizeParenthesize tokens
    catch ex
        if not ex.reason then throw ex
        all = []
        for token in tokens
            all = all.concat editorGenerateSyntaxHighlightingForToken token
        postMessage 
            error:
                reason: ex.reason
                before: e.data[...ex.starts]
                highlight: e.data[ex.starts..ex.ends]
            syntaxHighlighting: editorGenerateSyntaxHighlighting e.data, all
        close()
        return
      
    parsed = undefined
      
    try
        parsed = expressionParse parenthesized
    catch ex
        if not ex.reason then throw ex
        all = []
        for token in parenthesized
            all = all.concat editorGenerateSyntaxHighlightingForToken token
        postMessage 
            error:
                reason: ex.reason
                before: e.data[...ex.starts]
                highlight: e.data[ex.starts..ex.ends]
            syntaxHighlighting: editorGenerateSyntaxHighlighting e.data, all
        close()
        return

    syntaxHighlighting = editorGenerateSyntaxHighlighting e.data, editorGenerateSyntaxHighlightingForExpression parsed
        
    try
        inlined = expressionInline parsed, {}
    
        typeChecked = expressionTypeCheck inlined
            
        expressionGetPlurality typeChecked
            
        unrolled = expressionUnroll typeChecked
            
        postMessage
            result: JSON.stringify unrolled, null, 4
            syntaxHighlighting: syntaxHighlighting
            
    catch ex
        if not ex.reason then throw ex
        postMessage 
            error:
                reason: ex.reason
                before: e.data[...ex.starts]
                highlight: e.data[ex.starts..ex.ends]
            syntaxHighlighting: syntaxHighlighting
        close()
        return
        
tokenizeSplitByWhitespace = require "./../tokenize/splitByWhitespace"
tokenizeSplitToken = require "./../tokenize/splitToken"
tokenizeParenthesize = require "./../tokenize/parenthesize"
expressionParse = require "./../expression/parse"
expressionInline = require "./../expression/inline"
expressionTypeCheck = require "./../expression/typeCheck"
expressionGetPlurality = require "./../expression/getPlurality"
expressionUnroll = require "./../expression/unroll"
editorGenerateSyntaxHighlighting = require "./compiler/generateSyntaxHighlighting"
editorGenerateSyntaxHighlightingForExpression = require "./compiler/generateSyntaxHighlighting/forExpression"
editorGenerateSyntaxHighlightingForToken = require "./compiler/generateSyntaxHighlighting/forToken"