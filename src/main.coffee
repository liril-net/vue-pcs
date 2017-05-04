import Vue from 'vue'
import App from '@/App'
import router from '@/router'

Vue.config.productionTip = off

new Vue
  el: '#app'
  router: router
  components:
    App: App
  render: (h) ->
    h 'App', {}
