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
require 'google_maps_service'

require_relative 'test_load_all'

# load 'Rakefile'
# Rake::Task['db:reset'].invoke

CITY_NAME = 'Hsinchu'.freeze
ROUTE_ID = 'HSZ0007'.freeze
SUB_ROUTE_ID = 'HSZ000701'.freeze
STOP_ID = 'HSZ222237'.freeze
START_LAT = '24.7947302'.freeze
START_LNG = '120.9910429'.freeze
DEST_LAT = '24.7947729'.freeze
DEST_LNG = '120.975722'.freeze
ROUTE_NAME = '81'.freeze
START_LOCATION = '24.7947302,120.9910429'.freeze
END_LOCATION = '24.7947729,120.975722'.freeze
CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock
  c.ignore_hosts 'sqs.us-east-1.amazonaws.com'
end
