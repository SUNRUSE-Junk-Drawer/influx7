describe "expression", -> describe "parse", -> describe "call", ->
    rewire = require "rewire"
    describe "imports", ->
        expressionParseCall = rewire "./call"
        it "expressionParse", -> (expect expressionParseCall.__get__ "expressionParse").toBe require "./../parse"
        it "expressionParseArgumentList", -> (expect expressionParseCall.__get__ "expressionParseArgumentList").toBe require "./argumentList"
    describe "on calling", ->
        expressionParseCall = rewire "./call"
        run = (config) -> describe config.description, ->
            result = inputCopy = undefined
            beforeEach ->
                expressionParseCall.__set__ "expressionParse", (expr, declarations) ->
                    if config.parsesExpression
                        (expect expr).toEqual config.parsesExpression
                        (expect declarations).toEqual "test declarations"
                        "test parsed lambda expression"
                    else fail "unexpected call to parseExpression"
                expressionParseCall.__set__ "expressionParseArgumentList", (token, declarations) ->
                    if config.parsesArgumentList
                        (expect token).toEqual config.parsesArgumentList
                        (expect declarations).toEqual "test declarations"
                        "test parsed argument list"
                    else fail "unexpected call to expressionParseArgumentList"
                inputCopy = JSON.parse JSON.stringify config.input
                result = expressionParseCall config.input, "test declarations"
            it "does not modify the input", -> (expect inputCopy).toEqual config.input
            it "returns the expected output", -> (expect result).toEqual config.output
        
        run
            description: "nothing"
            input: []
            output: null
            
        run
            description: "one token"
            input: [
                token: "test token one"
                starts: 32
                ends: 65
            ]
            output: null
        
        run
            description: "one set of parentheses"
            input: [
                token: "("
                starts: 32
                ends: 65
                children: "test children"
            ]
            output: null
            
        run
            description: "one token followed by one set of parentheses"
            input: [
                    token: "test token one"
                    starts: 32
                    ends: 65
                ,
                    token: "("
                    starts: 70
                    ends: 89
                    children: "test children"
            ]
            parsesExpression: [
                token: "test token one"
                starts: 32
                ends: 65    
            ]
            parsesArgumentList:
                token: "("
                starts: 70
                ends: 89
                children: "test children"
            output:
                callLambda: "test parsed lambda expression"
                with: "test parsed argument list"
                starts: 70
                ends: 89
        
        run
            description: "one set of parentheses followed by one token"
            input: [
                    token: "("
                    starts: 32
                    ends: 65
                    children: "test children"
                ,
                    token: "test token one"
                    starts: 70
                    ends: 89
            ]
            output: null
            
        run
            description: "two tokens"
            input: [
                    token: "test token one"
                    starts: 32
                    ends: 65
                ,
                    token: "test token two"
                    starts: 70
                    ends: 89
            ]
            output: null
            
        run
            description: "two sets of parentheses"
            input: [
                    token: "("
                    starts: 32
                    ends: 65
                    children: "test children a"
                ,
                    token: "("
                    starts: 70
                    ends: 89
                    children: "test children b"
            ]
            parsesExpression: [
                token: "("
                starts: 32
                ends: 65
                children: "test children a"
            ]
            parsesArgumentList:
                token: "("
                starts: 70
                ends: 89
                children: "test children b"
            output:
                callLambda: "test parsed lambda expression"
                with: "test parsed argument list"
                starts: 70
                ends: 89
            
        run
            description: "one set of parentheses followed by two tokens"
            input: [
                    token: "("
                    starts: 32
                    ends: 65
                    children: "test children"
                ,
                    token: "test token one"
                    starts: 70
                    ends: 89
                ,
                    token: "test token two"
                    starts: 96
                    ends: 114
            ]
            output: null
            
        run
            description: "one token followed by one set of parentheses followed by one token"
            input: [
                    token: "test token one"
                    starts: 32
                    ends: 65
                ,
                    token: "("
                    starts: 70
                    ends: 89
                    children: "test children"
                ,
                    token: "test token two"
                    starts: 96
                    ends: 114
            ]
            output: null
            
        run
            description: "two tokens followed by one set of parentheses"
            input: [
                    token: "test token one"
                    starts: 32
                    ends: 65
                ,
                    token: "test token two"
                    starts: 70
                    ends: 89
                ,
                    token: "("
                    starts: 96
                    ends: 114
                    children: "test children"
            ]
            parsesExpression: [
                    token: "test token one"
                    starts: 32
                    ends: 65
                ,
                    token: "test token two"
                    starts: 70
                    ends: 89
            ]
            parsesArgumentList:
                token: "("
                starts: 96
                ends: 114
                children: "test children"
            output:
                callLambda: "test parsed lambda expression"
                with: "test parsed argument list"
                starts: 96
                ends: 114    
            
        run
            description: "one set of parentheses followed by one token followed by one set of parentheses"
            input: [
                    token: "("
                    starts: 32
                    ends: 65
                    children: "test children a"
                ,
                    token: "test token one"
                    starts: 70
                    ends: 89
                ,
                    token: "("
                    starts: 96
                    ends: 114
                    children: "test children b"
            ]
            parsesExpression: [
                    token: "("
                    starts: 32
                    ends: 65
                    children: "test children a"
                ,
                    token: "test token one"
                    starts: 70
                    ends: 89
            ]
            parsesArgumentList:
                token: "("
                starts: 96
                ends: 114
                children: "test children b"
            output:
                callLambda: "test parsed lambda expression"
                with: "test parsed argument list"
                starts: 96
                ends: 114          
                
        run
            description: "one token followed by one set of parentheses followed by one set of parentheses"
            input: [
                    token: "test token one"
                    starts: 32
                    ends: 65
                ,
                    token: "("
                    starts: 70
                    ends: 89
                    children: "test children a"
                ,
                    token: "("
                    starts: 96
                    ends: 114
                    children: "test children b"
            ]
            parsesExpression: [
                    token: "test token one"
                    starts: 32
                    ends: 65
                ,
                    token: "("
                    starts: 70
                    ends: 89
                    children: "test children a"
            ]
            parsesArgumentList:
                token: "("
                starts: 96
                ends: 114
                children: "test children b"
            output:
                callLambda: "test parsed lambda expression"
                with: "test parsed argument list"
                starts: 96
                ends: 114     