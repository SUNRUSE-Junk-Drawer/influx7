# A map function, wherein if one or more of the arguments are vectors, 
# they will be invoked for each item in that vector.  The resulting vector then 
# contains the same number of items.  Examples of this would include any 
# standard operator such as + or *:
# - (3, 5, 7) * 8 = (3 * 8), (5 * 8), (7 * 8)
# - (3, 5, 7) * (8, 2, 1) = (3 * 8), (5 * 2), (7 * 1)
# If the arguments are inconsistently plural (some are 4 and some are 7, for
# example), throws:
# - reason: "inconsistentPlurality"
# - starts: The number of characters between the beginning of the source code
#           and the start of the  token which caused the error.
# - ends: The number of characters between the beginning of the source code
#         and the end of the token which caused the error.
module.exports = functionPluralitiesMap = (argumentPluralities, starts, ends) -> 
    plurality = 1
    for argumentPlurality in argumentPluralities
        if argumentPlurality is 1 then continue
        if argumentPlurality is plurality then continue
        if plurality is 1
            plurality = argumentPlurality
        else if argumentPlurality isnt plurality then throw unused = 
            reason: "inconsistentPlurality"
            starts: starts
            ends: ends
    plurality or 1