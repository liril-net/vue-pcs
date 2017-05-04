path = require 'path'
webpack = require 'webpack'
merge = require 'webpack-merge'
CopyWebpackPlugin = require 'copy-webpack-plugin'
HtmlWebpackPlugin = require 'html-webpack-plugin'
ExtractTextPlugin = require 'extract-text-webpack-plugin'
OptimizeCSSPlugin = require 'optimize-css-assets-webpack-plugin'

utils = require './utils'
config = require '../config'
baseWebpackConfig = require './webpack.base.config'

env = config.build.env

webpackConfig = merge baseWebpackConfig,
  module:
    rules: utils.styleLoaders
      sourceMap: config.build.productionSourceMap
      extract: on
  devtool: if config.build.productionSourceMap then '#source-map' else off
  output:
    path: config.build.assetsRoot
    filename: utils.assetsPath 'js/[name].[chunkhash].js'
    chunkFilename: utils.assetsPath 'js/[id].[chunkhash].js'
  plugins: [
    new webpack.DefinePlugin
      'process.env': env
    new webpack.optimize.UglifyJsPlugin
      compress:
        warnings: off
      sourceMap: on
    new ExtractTextPlugin
      filename: utils.assetsPath 'css/[name].[contenthash].css'
    new OptimizeCSSPlugin
      cssProcessorOptions:
        safe: on
    new HtmlWebpackPlugin
      filename: config.build.index
      template: 'index.html'
      inject: on
      minify:
        removeComments: on
        collapseWhitespace: on
        removeAttributeQuotes: on
      chunksSortMode: 'dependency'
    new webpack.optimize.CommonsChunkPlugin
      name: 'vendor'
      minChunks: (module, count) ->
        module.resource and
        /\.js$/.test module.resource and
        (module.resource.indexOf path.join __dirname, '../node_modules') is 0
    new webpack.optimize.CommonsChunkPlugin
      name: 'manifest'
      chunks: ['vendor']
    new CopyWebpackPlugin [
      from: path.resolve __dirname, '../static'
      to: config.build.assetsSubDirectory
      ignore: ['.*']
    ]
  ]

if config.build.productionGzip
  CompressionWebpackPlugin = require('compression-webpack-plugin')

  webpackConfig.plugins.push new CompressionWebpackPlugin
    asset: '[path].gz[query]'
    algorithm: 'gzip'
    test: new RegExp "\\.(#{config.build.productionGzipExtensions.join('|')})$"
    threshold: 10240
    minRatio: 0.8

if config.build.bundleAnalyzerReport
  BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin
  webpackConfig.plugins.push new BundleAnalyzerPlugin()

module.exports = webpackConfig
