# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'http'
require 'base64'
require 'openssl'
require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

# require_relative '../lib/motc_api.rb'
require_relative '../lib/mapper/bus_stop_mapper.rb'

CITY_NAME = 'Hsinchu'
CITY_NAME.freeze
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
XDATE = Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
SIGN_DATE = 'x-date: ' + XDATE
HASH = OpenSSL::HMAC.digest('sha1', CONFIG['APP_KEY'].to_s, SIGN_DATE)
SIGNATURE = Base64.encode64(HASH)
# AUTH_CODE IS GH_TOKEN IN THIS PROJECT
AUTH_CODE = 'hmac username="' + CONFIG['APP_ID'].to_s + ', algorithm="hmac-sha1"
            , headers="x-date", signature="' + SIGNATURE + '"'
CORRECT = YAML.safe_load(File.read('spec/fixtures/bs_results.yml'))
RESPONSE = YAML.load(File.read('spec/fixtures/bs_response.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTES_FOLDER.freeze
CASSETTE_FILE = 'motc_api'
CASSETTE_FILE.freeze
