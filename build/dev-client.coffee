require 'eventsource-polyfill'

hotClient = require 'webpack-hot-middleware/client?noInfo=true&reload=true'

hotClient.subscribe (evnet) ->
  if evnet.action is 'reload' then window.location.reload()
