# frozen_string_literal: true

require 'http'
require 'yaml'
require 'base64'
require 'openssl'

config = YAML.safe_load(File.read('config/secrets.yml'))

MOTC_ID = config['development']['MOTC_ID']
MOTC_KEY = config['development']['MOTC_KEY']

xdate = Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
sign_date = 'x-date: ' + xdate

hash = OpenSSL::HMAC.digest('sha1', MOTC_KEY, sign_date)
signature = Base64.encode64(hash)
signature.delete!("\n")

auth_code = 'hmac username="' + MOTC_ID +
            '", algorithm="hmac-sha1", headers="x-date", signature="' +
            signature + '"'

def motc_api_path(path)
  'http://ptx.transportdata.tw/MOTC/v2/Bus/StopOfRoute/City/' + path
end

def call_motc_url(auth_code, date, url)
  HTTP.headers('x-date' => date, 'Authorization' => auth_code).get(url)
end

sor_responses = {}
sor_results = {}
temp_hash = []

## GOOD REPO (HAPPY)
good_request = motc_api_path('Hsinchu')
sor_responses[good_request] = call_motc_url(auth_code, xdate, good_request)
stop_of_routes = sor_responses[good_request].parse

stop_of_routes.map do |bus_route_data|
  route_id = bus_route_data['RouteUID']
  sub_route_id = bus_route_data['SubRouteUID']
  direction = bus_route_data['Direction']
  bus_route_data['Stops'].map do |stop|
    stop['RouteUID'] = route_id
    stop['SubRouteUID'] = sub_route_id
    stop['Direction'] = direction
    temp_hash << stop
  end
end

# 65 avaiable routes in Hsinchu
sor_results['size'] = temp_hash.count
# list stop of routes
sor_results['stops'] = temp_hash

## BAD REPO (SAD)
bad_request = motc_api_path('Tokyo')
sor_responses[bad_request] = call_motc_url(auth_code, xdate, bad_request)
sor_responses[bad_request].parse

File.write('spec/fixtures/sor_responses.yml', sor_responses.to_yaml)
File.write('spec/fixtures/sor_results.yml', sor_results.to_yaml)
