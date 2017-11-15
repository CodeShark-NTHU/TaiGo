# frozen_string_literal: false

source 'https://rubygems.org'
ruby '2.4.2'

# Networking gems
gem 'http'

# Web app related
gem 'econfig'
gem 'puma'
gem 'roda'
# gem 'pry' # to run console in production
# gem 'rake' # to run migrations in production

# Database related
gem 'hirb'
gem 'sequel'

# Data gems
gem 'dry-struct'
gem 'dry-types'

# Representers
gem 'multi_json'
gem 'roar'

# Services
gem 'dry-monads'
gem 'dry-transaction'

group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack-test'
  gem 'rake'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'sqlite3'

  gem 'database_cleaner'

  gem 'pry'
  gem 'rerun'

  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end

# group :production do
#   gem 'pg'
# end
