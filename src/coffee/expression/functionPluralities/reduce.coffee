# A map function, wherein if one or more of the arguments are vectors, 
# they will be invoked for each item in that vector.  The resulting vector then 
# always contains only one item.  Examples of this would include sum/product:
# - sum (32, 8, 15) = 32 + 8 + 15
# If the arguments are inconsistently plural (some are 4 and some are 7, for
# example), throws:
# - reason: "inconsistentPlurality"
# - starts: The number of characters between the beginning of the source code
#           and the start of the  token which caused the error.
# - ends: The number of characters between the beginning of the source code
#         and the end of the token which caused the error.
module.exports = expressionFunctionPluralitiesReduce = 
    (argumentPluralities, starts, ends) -> 
        plurality = 1
        for argumentPlurality in argumentPluralities
            if argumentPlurality is 1 then continue
            if argumentPlurality is plurality then continue
            if plurality is 1
                plurality = argumentPlurality
            else throw unused = 
                reason: "inconsistentPlurality"
                starts: starts
                ends: ends
        1