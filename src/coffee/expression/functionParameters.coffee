# An object where keys are the names of untyped functions and values are 
# objects.  These objects contain a key for each typed function that operator 
# could map to, where the values are arrays of strings specifying the types of
# the parameters required by it.
module.exports = expressionFunctionParameters = 
    concatenate:
        concatenateBoolean: ["boolean", "boolean"]
        concatenateFloat: ["float", "float"]
        concatenateInteger: ["integer", "integer"]
    any:
        anyBoolean: ["boolean"]
    all:
        allBoolean: ["boolean"]
    sum:
        sumInteger: ["integer"]
        sumFloat: ["float"]
    product:
        productInteger: ["integer"]
        productFloat: ["float"]
    and:
        andBoolean: ["boolean", "boolean"]
    or:
        orBoolean: ["boolean", "boolean"]
    not:
        notBoolean: ["boolean"]
    add:
        addInteger: ["integer", "integer"]
        addFloat: ["float", "float"]
    subtract:
        subtractInteger: ["integer", "integer"]
        subtractFloat: ["float", "float"]
    multiply:
        multiplyInteger: ["integer", "integer"]
        multiplyFloat: ["float", "float"]
    divide:
        divideFloat: ["float", "float"]
    negate:
        negateInteger: ["integer"]
        negateFloat: ["float"]
    equal:
        equalBoolean: ["boolean", "boolean"]
        equalInteger: ["integer", "integer"]
        equalFloat: ["float", "float"]
    notEqual:
        notEqualBoolean: ["boolean", "boolean"]
        notEqualInteger: ["integer", "integer"]
        notEqualFloat: ["float", "float"]
    lessThan:
        lessThanInteger: ["integer", "integer"]
        lessThanFloat: ["float", "float"]
    lessThanOrEqual:
        lessThanOrEqualInteger: ["integer", "integer"]
        lessThanOrEqualFloat: ["float", "float"]
    greaterThan:
        greaterThanInteger: ["integer", "integer"]
        greaterThanFloat: ["float", "float"]
    greaterThanOrEqual:
        greaterThanOrEqualInteger: ["integer", "integer"]
        greaterThanOrEqualFloat: ["float", "float"]