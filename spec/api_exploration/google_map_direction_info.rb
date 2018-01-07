# frozen_string_literal: true

require 'http'
require 'yaml'
require 'google_maps_service'

config = YAML.safe_load(File.read('config/secrets.yml'))
GOOGLE_MAP_KEY = config['development']['GOOGLE_MAP_KEY']
GOOGLE_MAP_RETRY_TIMEOUT = config['development']['GOOGLE_MAP_RETRY_TIMEOUT']
GOOGLE_MAP_QUERIES_PER_SECOND = config['development']['GOOGLE_MAP_QUERIES_PER_SECOND']

GoogleMapsService.configure do |cg|
  cg.key = GOOGLE_MAP_KEY
  cg.retry_timeout = GOOGLE_MAP_RETRY_TIMEOUT
  cg.queries_per_second = GOOGLE_MAP_QUERIES_PER_SECOND
end

# Initialize client using global parameters
@gmaps = GoogleMapsService::Client.new

def call_gm_direction(request)
  loc = request.split('/')
  startlocation = "#{loc[0]},#{loc[1]}"
  endlocation = "#{loc[2]},#{loc[3]}"
  # Simple directions
  routes = @gmaps.directions(
    startlocation.to_s,
    endlocation.to_s,
    mode: 'transit',
    language: 'zh-TW', # en zh-TW
    alternatives: true)
  routes
end

gmd_response = {}
gmd_results = {}

# GOOD GOOGLE_MAP_DIRECTION (HAPPY)
good_request = '24.7947302/120.9910429/24.7947729/120.975722'
gmd_response[good_request] = good_request
directions = call_gm_direction(good_request)
bus_hash = directions[1][:legs][0][:steps][1]
bus_detail = bus_hash[:transit_details]
# should be TRANSIT
gmd_results['travel_mode'] = bus_hash[:travel_mode]
# should be 2, the subtract 1 is only by walking
gmd_results['transit_direction_size'] = directions.count - 1
# should be 藍1區
gmd_results['route_name'] =bus_detail[:line][:short_name]
# should be 新竹高中
gmd_results['arrival_stop'] = bus_detail[:arrival_stop][:name]
# should be 水源地
gmd_results['departure_stop'] = bus_detail[:departure_stop][:name]
# should provide all information about transit direction 藍1區 
gmd_results['transit_direction'] = directions[1]

## BAD GOOGLE_MAP_DIRECTION (SAD)
bad_request = '0/0/0/0'
gmd_response[bad_request] = bad_request
symbol_removed = gmd_results.to_yaml.gsub!(' :', '')
slash_formated = symbol_removed.to_yaml.gsub!(' -', '- ')
File.write('spec/fixtures/gmd_response.yml', gmd_response.to_yaml)
File.write('spec/fixtures/gmd_results.yml', slash_formated)
