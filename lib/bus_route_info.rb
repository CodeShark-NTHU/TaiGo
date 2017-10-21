require 'http'
require 'yaml'
require_relative 'motc_api.rb'

br_response = {}
br_results = {}

## GOOD REPO (HAPPY)
good_request_path = %w[Route City Hsinchu].join('/')
good_request = MotcApi::Request.new(good_request_path)
br_response[request.url] = good_request.execute
routes = br_response[good_request.url].parse

# should be 28
br_results['routes'] = routes.count
br_results['routes'] = routes

## BAD REPO (SAD)
bad_request_path = %w[Route City Tokyo].join('/')
bad_request MotcApi::Request.new(bad_request_path)
br_response[bad_request.url] = bad_request.execute.parse

File.write('spec/fixtures/br_response.yml', br_response.to_yaml)
File.write('spec/fixtures/br_results.yml', br_results.to_yaml)
