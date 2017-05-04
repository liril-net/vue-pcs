path = require 'path'
config = require '../config'
ExtractTextPlugin = require 'extract-text-webpack-plugin'

isProduction = process.env.NODE_ENV is 'production'

exports.assetsPath = (_path) ->
  assetsSubDirectory = if isProduction then config.build.assetsSubDirectory else config.dev.assetsSubDirectory
  path.posix.join assetsSubDirectory, _path

exports.cssLoaders = (options = {}) ->
  cssLoader =
    loader: 'css-loader'
    options:
      minimize: isProduction
      sourceMap: options.sourceMap

  # generate loader string to be used with extract text plugin
  generateLoaders = (loader, loaderOptions) ->
    loaders = [cssLoader]
    if loader
      loaders.push
        loader: "#{loader}-loader"
        options: Object.assign {}, loaderOptions,
          sourceMap: options.sourceMap

    if options.extract
      ExtractTextPlugin.extract
        use: loaders
        fallback: 'vue-style-loader'
    else
      ['vue-style-loader', loaders...]

  css: generateLoaders()
  postcss: generateLoaders()
  less: generateLoaders 'less'
  sass: generateLoaders 'sass',
    indentedSyntax: on
  scss: generateLoaders 'sass'
  stylus: generateLoaders 'stylus'
  styl: generateLoaders 'stylus'

exports.styleLoaders = (options) ->
  output = []
  for extension, loader of exports.cssLoaders(options)
    output.push
      test: new RegExp "\\.#{extension}$"
      use: loader
  return output
