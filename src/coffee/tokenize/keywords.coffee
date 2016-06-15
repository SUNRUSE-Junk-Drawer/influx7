# Exports an array of every keyword.
# This is similar to "symbols", but for things which do not split tokens.
module.exports = tokenizeKeywords = ["false", "true"]

for operator, keywords of require "./../expression/parse/operatorKeywords"
    for keyword in keywords
        module.exports.push keyword