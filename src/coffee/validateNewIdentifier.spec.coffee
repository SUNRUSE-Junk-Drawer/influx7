describe "validateNewIdentifier", ->
    rewire = require "rewire"
    describe "imports", ->
        validateNewIdentifier = rewire "./validateNewIdentifier"
        it "isIdentifier", -> (expect validateNewIdentifier.__get__ "isIdentifier").toBe require "./isIdentifier"
    describe "on calling", ->
        validateNewIdentifier = rewire "./validateNewIdentifier"
        declarations = 
            testExistingIdentifierA: "test value"
            testExistingIdentifierB: "test value"
            testExistingIdentifierC: "test value"
        run = (config) -> describe config.description, ->
            inputCopy = declarationsCopy = undefined
            beforeEach ->
                inputCopy = JSON.parse JSON.stringify config.input
                declarationsCopy = JSON.parse JSON.stringify declarations
                validateNewIdentifier.__set__ "isIdentifier", (token) -> 
                    (expect token).toEqual config.input.token
                    config.isIdentifier
            if config.throws
                it "throws the expected exception", -> (expect -> validateNewIdentifier inputCopy, declarationsCopy).toThrow config.throws
            else
                it "does nothing", -> validateNewIdentifier inputCopy, declarationsCopy
            describe "then", ->
                beforeEach ->
                    try
                        validateNewIdentifier inputCopy, declarationsCopy
                    catch e
                it "does not modify the input", -> (expect inputCopy).toEqual config.input
                it "does not modify the declarations", -> (expect declarationsCopy).toEqual declarations
        run
            description: "valid"
            input: 
                token: "testNewIdentifier"
                starts: 33
                ends: 47
            isIdentifier: true
        run
            description: "not a valid identifier"
            input: 
                token: "testNewIdentifier"
                starts: 33
                ends: 47
            isIdentifier: false
            throws:
                reason: "identifierInvalid"
                starts: 33
                ends: 47
        run
            description: "already defined"
            input: 
                token: "testExistingIdentifierB"
                starts: 33
                ends: 47
            isIdentifier: true
            throws:
                reason: "identifierNotUnique"
                starts: 33
                ends: 47