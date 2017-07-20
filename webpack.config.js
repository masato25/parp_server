var webpack = require("webpack");
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");
var path = require('path')
var phoenixStaticPath = path.join(__dirname, 'web/static')

module.exports = {
  context: path.join(__dirname, ''),
  entry: {
    app: phoenixStaticPath + "/js/app.js",
    page_1: phoenixStaticPath + "/js/jsx/page/page_1.jsx",
    avatar_1: phoenixStaticPath + "/js/jsx/page/avatar_1.jsx",
    login_1: phoenixStaticPath + "/js/jsx/login/login_1.jsx",
    car_1: phoenixStaticPath + "/js/jsx/car/car_1.jsx",
    app: phoenixStaticPath + "/css/app.scss",
  },
  output: {
    path: path.join(__dirname, "/priv/static/"),
    filename: "js/[name].js"
  },

  resolve: {
    extensions: [".js", ".jsx", ".css", "scss"],
    alias: {
      Vue: "vue/dist/vue.js",
      jquery: "jquery/dist/jquery.js",
      'jquery-datepicker': 'jquery-datepicker/jquery-datepicker.js',
      'jquery-ui': 'jquery-ui-bundle/jquery-ui.js',
    },
  },

  module: {
    loaders: [
      {
        test: /\.css$/,
        loader: "css-loader"
      },
      {
        test: /\.(sass|scss)$/,
        loader: ExtractTextPlugin.extract(["css-loader", "sass-loader"])
      },
      {
        test: /\.(js|jsx)$/,
        loader: 'babel-loader',
        exclude: /(node_modules|bower_components)/,
        query: {
          presets: ['es2015', 'react']
        },
      },
      {
        test: /\.less$/,
        loader: 'style!css!less'
      },
      {
        test: /\.json$/,
        loader: 'json-loader'
      },
      {
        test: /\.png$/,
        loader: "url-loader?limit=100000"
      }
   ]
  },

  plugins: [
    new ExtractTextPlugin({
      filename: "css/[name].css",
      allChunks: true,
    }),
    new CopyWebpackPlugin([
      { from: path.join(__dirname, 'web/static/assets') },
      { from: path.join(__dirname, 'web/static/vendor'), to: path.join(__dirname, 'priv/static/vendor')},
    ]),
     new webpack.ProvidePlugin({
      $:"jquery",
      "jQuery":"jquery",
      "window.jQuery":"jquery"
    }),
    /*new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    }),
    new webpack.optimize.UglifyJsPlugin()
    */
  ],
};
