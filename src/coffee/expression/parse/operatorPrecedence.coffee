# Exports an array of objects representing operator precedence levels, 
# containing "unary" and "binary" properties which are arrays of strings 
# specifying the operators on that level.
module.exports = expressionOperatorPrecedence = [
        unary: []
        binary: ["and"]
    ,
        unary: ["not"]
        binary: []
    ,
        unary: []
        binary: ["or"]
    ,
        unary: []
        binary: [
            "equal"
            "notEqual"
            "greaterThan"
            "greaterThanOrEqual"
            "lessThan"
            "lessThanOrEqual"
        ]
    ,
        unary: ["sum", "product", "any", "all"]
        binary: []
    ,
        unary: []
        binary: ["concatenate"]
    ,
        unary: []
        binary: ["subtract"]
    ,
        unary: []
        binary: ["add"]
    ,
        unary: []
        binary: ["multiply"]
    ,
        unary: []
        binary: ["divide"]
    ,
        unary: ["negate"]
        binary: []
]