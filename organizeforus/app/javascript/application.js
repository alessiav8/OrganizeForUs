// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//import "@hotwired/turbo-rails"

import "controllers"
import * as jq from 'jquery'
import * as Preview from "./img_preview.js"
window.Preview = Preview

/*require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")*/

window.importmapScriptsLoaded = true