# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.5'
gem 'bigdecimal'
gem 'bootsnap', require: false
gem 'devise'
gem 'faker'
gem 'google-api-client'
gem 'graphiql-rails'
gem 'graphql'
gem 'importmap-rails'
gem 'jbuilder'
gem 'mutex_m'
gem 'mysql2', '~> 0.5'
gem 'ostruct'
gem 'parallel'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.8', '>= 7.0.8.6'
gem 'sassc-rails'
gem 'slim-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv'
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-rails'
end

group :development do
  gem 'bullet'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
