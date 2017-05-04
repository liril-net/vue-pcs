utils = require './utils'
config = require '../config'
isProduction = process.env.NODE_ENV is 'production'

cssLoaders = utils.cssLoaders
  sourceMap: if isProduction then config.build.productionSourceMap else config.dev.cssSourceMap
  extract: isProduction

module.exports =
  use: cssLoaders

