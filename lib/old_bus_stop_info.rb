# frozen_string_literal: true

require 'http'
require 'yaml'
require_relative 'motc_api.rb'

bs_response = {}
bs_results = {}

## GOOD REPO (HAPPY)
good_request = MotcApi::Request.new(%w[Stop City Hsinchu].join('/'))
bs_response[request.url] = good_request.execute
stops = bs_response[good_request.url].parse

bs_results['size'] = stops.count
# should be 30
bs_results['AuthorityID'] = stops[0]['AuthorityID']

# should have info about 12
bs_results['stops'] = stops

bad_request MotcApi::Request.new(%w[Stop City Tokyo].join('/'))
bs_response[bad_request.url] = bad_request.execute.parse

File.write('spec/fixtures/bs_response.yml', bs_response.to_yaml)
File.write('spec/fixtures/bs_results.yml', bs_results.to_yaml)
