path = require 'path'
utils = require './utils'
config = require '../config'
vueLoaderConfig = require './vue-loader.conf'

isProduction = process.env.NODE_ENV is 'production'

resolve = (dir) ->
  path.join __dirname, '..', dir

module.exports =
  entry:
    app: './src/main'

  output:
    path: resolve 'dist'
    filename: '[name].js'
    publicPath: if isProduction then config.build.assetsPublicPath else config.dev.assetsPublicPath

  resolve:
    extensions: ['.coffee', '.js', '.vue', '.json']
    alias:
      'vue$': 'vue/dist/vue.esm.js',
      '@': resolve 'src'

  module:
    rules: [
      test: /\.coffee$/
      rules: [
        loader: 'coffee-loader'
      ,
        loader: 'babel-loader'
        enforce: 'post'
      ]
      exclude: [
        resolve 'node_modules'
      ]
    ,
      test: /\.vue$/
      loader: 'vue-loader'
      options: vueLoaderConfig
    ,
      test: /\.(png|jpe?g|gif|svg)(\?.*)?$/
      loader: 'url-loader'
      options:
        limit: 10000
        name: utils.assetsPath 'img/[name].[hash:7].[ext]'
    ,
      test: /\.(woff2?|eot|ttf|otf)(\?.*)?$/
      loader: 'url-loader'
      options:
        limit: 10000
        name: utils.assetsPath 'fonts/[name].[hash:7].[ext]'
    ]
