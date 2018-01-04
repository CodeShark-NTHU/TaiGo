# frozen_string_literal: false

ENV['RACK_ENV'] = 'development'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require 'http'
require 'base64'
require 'openssl'

require_relative 'test_load_all'

# load 'Rakefile'
# Rake::Task['db:reset'].invoke

CITY_NAME = 'Hsinchu'.freeze
SUB_ROUTE_ID = 'HSZ000701'.freeze
ROUTE_NAME = '81'.freeze
CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock
  c.ignore_hosts 'sqs.us-east-1.amazonaws.com'
end
