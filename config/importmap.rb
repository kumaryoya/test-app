# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'jquery', to: 'jquery/dist/jquery.min.js'
pin 'bootstrap', to: 'bootstrap/dist/js/bootstrap.min.js'
pin 'admin-lte', to: 'admin-lte/dist/js/adminlte.min.js'
