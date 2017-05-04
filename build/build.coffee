require('./check-versions')()

process.env.NODE_ENV = 'production'

ora = require 'ora'
rm = require 'rimraf'
path = require 'path'
chalk = require 'chalk'
webpack = require 'webpack'
config = require '../config'
webpackConfig = require './webpack.prod.conf'

spinner = ora 'Building for production...'
spinner.start()

files = path.join config.build.assetsRoot, config.build.assetsSubDirectory

rm files, (err) ->
  if err then throw err

  webpack webpackConfig, (err, stats) ->
    spinner.stop()
    if err then throw err

    process.stdout.write "#{stats.toString
      colors: true
      modules: false
      children: false
      chunks: false
      chunkModules: false}\n\n"

    console.log chalk.cyan '  Build complete.\n'
    console.log chalk.yellow(
      '  Tip: built files are meant to be served over an HTTP server.\n'
      '  Opening index.html over file:// won\'t work.\n'
    )
