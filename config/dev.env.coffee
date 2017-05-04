merge = require 'webpack-merge'
prodEnv = require './prod.env'

devEnv =
  NODE_ENV: '"development"'

module.exports =
  merge prodEnv, devEnv
