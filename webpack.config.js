var ExtractTextPlugin = require("extract-text-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");
var phoenixStaticPath = "./web/static/custom_js"
var path = require('path')

module.exports = {
  context: path.join(__dirname, ''),
  entry: {
    app: phoenixStaticPath + "/../js/app.js",
    page_1: phoenixStaticPath + "/page/page_1.jsx",
    avatar_1: phoenixStaticPath + "/page/avatar_1.jsx",
  },

  output: {
    path: "./priv/static/",
    filename: "js/[name].js"
  },

  module: {
    loaders: [{
      test: /\.js$/,
      exclude: /node_modules/,
      loader: "babel",
      include: __dirname,
      query: {
        presets: ["es2015"]
      }
    }, {
      test: /\.css$/,
      use: [ 'style-loader', 'css-loader' ],
      loader: ExtractTextPlugin.extract("style", "css")
    },{
      test: /\.scss$/,
      loader: ExtractTextPlugin.extract("style", "css!sass"),
    },{
      test: /\.jsx?$/,
      exclude: /(node_modules|bower_components)/,
      loader: 'babel-loader',
      query: {
        plugins: ['recharts'],
        presets: ['es2015', 'react']
      }
    },{
      test: /\.less$/,
      loader: 'style!css!less'
    },{
      test: /\.json$/,
      loader: 'json-loader'
    }]
  },

  resolve: {
    modulesDirectories: [ "node_modules", __dirname + "/web/static/js" ],
    alias: {
      Chartist: "chartist/dist/chartist.js",
      Vue: "vue/dist/vue.js",
      jQuery: "jquery/dist/jquery.js",
      "jquery-datepicker": "jquery-datepicker/jquery-datepicker.js",
    },
  },

  plugins: [
    new ExtractTextPlugin("css/app.css"),
    new CopyWebpackPlugin([{ from: "./web/static/assets" }]),
  ],

};
