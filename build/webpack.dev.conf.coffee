webpack = require 'webpack'
merge = require 'webpack-merge'
HtmlWebpackPlugin = require 'html-webpack-plugin'
FriendlyErrorsPlugin = require 'friendly-errors-webpack-plugin'

utils = require './utils'
config = require '../config'
baseWebpackConfig = require './webpack.base.config'

for name of baseWebpackConfig.entry
  baseWebpackConfig.entry[name] = ['./build/dev-client', baseWebpackConfig.entry[name]]

module.exports = merge baseWebpackConfig,
  module:
    rules: utils.styleLoaders
      sourceMap: config.dev.cssSourceMap
  devtool: '#cheap-module-eval-source-map'
  plugins: [
    new webpack.DefinePlugin
      'process.env': config.dev.env
    new webpack.HotModuleReplacementPlugin()
    new webpack.NoEmitOnErrorsPlugin()
    new HtmlWebpackPlugin
      filename: 'index.html'
      template: 'index.html'
      inject: on
    new FriendlyErrorsPlugin()
  ]
