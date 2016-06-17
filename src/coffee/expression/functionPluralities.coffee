# Exports an object where the keys are the names of typed functions, and the
# values describe their plurality; how they behave given more than one item in
# their arguments.
# - When the function has no special behaviour, "map".  If one or more of its
#   arguments are vectors, it will be invoked for each item in that vector.
#   The resulting vector then contains the same number of items.
#   Examples of this would include any standard operator such as + or *.
#   (3, 5, 7) * 8 = (3 * 8), (5 * 8), (7 * 8)
#   (3, 5, 7) * (8, 2, 1) = (3 * 8), (5 * 2), (7 * 1)
# - When the function combines the items in its arguments, "concatenate".  This
#   means that if the first argment has 2 items, the second has 5 and the third
#   has 8, 15 are returned.
#   This is used by the "," operator.
# - When the function takes any number of items in its arguments and returns a
#   single item, "fold".  
#   If any of the operators have only 1 item, they are expanded similar to 
#   "map".
#   This is used by dot, magnitude, distance, etc.
#   (3, 5, 7) dot 8 = (3, 5, 7) dot (8, 8, 8)
# - When the function takes a specific number of items, an object containing:
#   + input: The number of items taken in its arguments.
#   + output: The number of items returned.
#   If any of the operators have only 1 item, they are expanded similar to 
#   "map".
#   This is used by cross.
#   (3, 1, 2) cross 8 = (3, 1, 2) cross (8, 8, 8)
module.exports = expressionFunctionPluralities = 
    concatenateBoolean: "concatenate"
    concatenateInteger: "concatenate"
    concatenateFloat: "concatenate"

    addFloat: "map"
    subtractFloat: "map"
    multiplyFloat: "map"
    divideFloat: "map"
    negateFloat: "map"
    
    equalFloat: "map"
    notEqualFloat: "map"
    lessThanFloat: "map"
    greaterThanFloat: "map"
    lessThanOrEqualFloat: "map"
    greaterThanOrEqualFloat: "map"
    
    addInteger: "map"
    subtractInteger: "map"
    multiplyInteger: "map"
    negateInteger: "map"
    
    equalInteger: "map"
    notEqualInteger: "map"
    lessThanInteger: "map"
    greaterThanInteger: "map"
    lessThanOrEqualInteger: "map"
    greaterThanOrEqualInteger: "map"
    
    notBoolean: "map"
    orBoolean: "map"
    andBoolean: "map"
    equalBoolean: "map"
    notEqualBoolean: "map"