# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "img_preview"
pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.js"
#pin "jquery-ui-dist", to: "https://ga.jspm.io/npm:jquery-ui-dist@1.13.1/jquery-ui.js"
pin "jqtree", to: "https://ga.jspm.io/npm:jqtree@1.6.2/lib/tree.jquery.js"
#pin "jquery", to: "jquery.min.js", preload: true
#pin "jquery_ujs", to: "jquery_ujs.js", preload: true
#pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
