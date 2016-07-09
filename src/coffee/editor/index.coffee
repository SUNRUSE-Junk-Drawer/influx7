window.addEventListener "load", ->
    
tokenize = require "./../tokenize"
expressionParse = require "./../expression/parse"
typeCheck = require "./../expression/typeCheck"
unroll = require "./../expression/unroll"