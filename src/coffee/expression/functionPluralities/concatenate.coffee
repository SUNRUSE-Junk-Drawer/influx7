# A plurality function, wherein the result plurality is the sum of its
# arguments' plurality.
module.exports = expressionFunctionPluralitiesConcatenate = 
    (argumentPluralities) -> argumentPluralities.reduce (a, b) -> a + b