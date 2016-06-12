describe "tokenize", -> describe "splitByWhitespace", ->
    describe "on calling", ->
        tokenizeSplitByWhitespace = require "./splitByWhitespace"
        
        it "returns empty for empty", -> (expect tokenizeSplitByWhitespace "").toEqual []
        it "returns empty for whitespace", -> (expect tokenizeSplitByWhitespace "    ").toEqual []
        it "returns empty for whitespace with newlines", -> (expect tokenizeSplitByWhitespace   """
        
        
        
                                                                                        """).toEqual []
                                                                                        
        it "finds a single token", -> (expect tokenizeSplitByWhitespace "testToken2378$").toEqual [
            token: "testtoken2378$"
            starts: 0
        ]
        
        it "finds a single token preceded by whitespace", -> (expect tokenizeSplitByWhitespace "   testToken2378$").toEqual [
            token: "testtoken2378$"
            starts: 3
        ]
        
        it "finds a single token preceded by whitespace including newlines", -> (expect tokenizeSplitByWhitespace   """
            
            
            
            testToken2378$
                                                                                                            """).toEqual [
            token: "testtoken2378$"
            starts: 3
        ]
        
        it "finds a single token followed by whitespace", -> (expect tokenizeSplitByWhitespace "testToken2378$     ").toEqual [
            token: "testtoken2378$"
            starts: 0
        ]
        
        it "finds a single token followed by whitespace including newlines", -> (expect tokenizeSplitByWhitespace   """
            testToken2378$
            
            
            
                                                                                                            """).toEqual [
            token: "testtoken2378$"
            starts: 0
        ]
        
        it "finds multiple tokens split by whitespace or newlines", -> (expect tokenizeSplitByWhitespace    """
                testToken2378$  SOMEmoretokens 2furtherTOKEN
                
                
                followingNewlinesToken withMORE!after
                  andMoreHere
                                                                                                    """).toEqual [
                token: "testtoken2378$"
                starts: 0
            ,
                token: "somemoretokens"
                starts: 16
            ,
                token: "2furthertoken"
                starts: 31
            ,
                token: "followingnewlinestoken"
                starts: 47
            ,
                token: "withmore!after"
                starts: 70
            ,
                token: "andmorehere"
                starts: 87
        ]