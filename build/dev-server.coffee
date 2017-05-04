require('./check-versions')()

config = require '../config'

unless process.env.NODE_ENV then process.env.NODE_ENV = JSON.parse config.dev.env.NODE_ENV

opn = require 'opn'
path = require 'path'
express = require 'express'
webpack = require 'webpack'
proxyMiddleware = require 'http-proxy-middleware'
webpackConfig = require './webpack.dev.conf'

port = process.env.PORT or config.dev.port
autoOpenBrowser = config.dev.autoOpenBrowser
proxyTable = config.dev.proxyTable

app = express()
compiler = webpack webpackConfig

devMiddleware = require('webpack-dev-middleware') compiler,
  publicPath: webpackConfig.output.publicPath
  quiet: on

hotMiddleware = require('webpack-hot-middleware') compiler,
  log: -> {}

compiler.plugin 'compilation', (compilation) ->
  compilation.plugin 'html-webpack-plugin-after-emit', (data, cb) ->
    hotMiddleware.publish
      action: 'reload'
    cb()

for context, options of proxyTable
  if typeof options is 'string'
    options =
      target: options
  app.use proxyMiddleware options.filter or context, options

app.use require('connect-history-api-fallback')()
app.use devMiddleware
app.use hotMiddleware

staticPath = path.posix.join config.dev.assetsPublicPath, config.dev.assetsSubDirectory
app.use staticPath, express.static './static'

uri = "http://localhost:#{port}"

_resovle = null
readyPromise = new Promise (resolve) -> _resovle = resolve

console.log '> Starting dev server...'
devMiddleware.waitUntilValid ->
  console.log "> Listening at #{uri} \n"

  if autoOpenBrowser and process.env.NODE_ENV isnt 'testing' then opn uri
  _resovle()

server = app.listen port

module.exports =
  ready: readyPromise
  close: -> server.close()
