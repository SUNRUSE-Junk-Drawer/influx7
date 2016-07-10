# Exports an object, where the keys are the names of primitive types and the
# values are strings specifying the typed function to use to concatenate them.
module.exports = 
    boolean: "concatenateBoolean"
    integer: "concatenateInteger"
    float: "concatenateFloat"