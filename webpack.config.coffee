module.exports = 
    entry: "./src/coffee/editor/index"
    output: 
        path: "./src/clr/SUNRUSE.Influx.Web/Scripts"
        filename: "Editor.js"
    module:
        loaders: [
            test: /\.coffee$/
            loader: "coffee-loader"
        ]
    resolve:
        extensions: ["", ".webpack.js", ".web.js", ".js", ".coffee"]