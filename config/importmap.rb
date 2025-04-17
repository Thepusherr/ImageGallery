# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin 'filepond', to: 'https://ga.jspm.io/npm:filepond@4.30.4/dist/filepond.js', preload: true
pin 'aos', to: 'aos.js', preload: true
pin "turbo_stream_handler"
pin "comment_form_handler"
pin "jquery_comment_handler"
pin "ujs_comment_handler"
pin "direct_upload"
pin "rails_ujs_handler"
pin "vanilla_handler"
pin_all_from "app/javascript/controllers", under: "controllers"
