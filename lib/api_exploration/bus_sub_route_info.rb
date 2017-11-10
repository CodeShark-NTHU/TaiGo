# frozen_string_literal: true

require 'http'
require 'yaml'
require 'base64'
require 'openssl'

config = YAML.safe_load(File.read('config/secrets.yml'))

motc_id = config['development']['motc_id']
motc_key = config['development']['motc_key']

xdate = Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
sign_date = 'x-date: ' + xdate

hash = OpenSSL::HMAC.digest('sha1', motc_key, sign_date)
signature = Base64.encode64(hash)
signature.delete!("\n")

auth_code = 'hmac username="' + motc_id +
            '", algorithm="hmac-sha1", headers="x-date", signature="' +
            signature + '"'

def motc_api_path(path)
  'http://ptx.transportdata.tw/MOTC/v2/Bus/Route/City/' + path
end

def call_motc_url(auth_code, date, url)
  HTTP.headers('x-date' => date, 'Authorization' => auth_code).get(url)
end

bsr_response = {}
bsr_results = {}
temp_hash = []

## GOOD REPO (HAPPY)
good_request = motc_api_path('Hsinchu')
bsr_response[good_request] = call_motc_url(auth_code, xdate, good_request)
routes = bsr_response[good_request].parse

routes.map do |route|
  route_uid = route['RouteUID']
  route['SubRoutes'].map do |subr|
    subr['RouteUID'] = route_uid
    temp_hash << subr
  end
end

# 65 available routes in Hsinchu
bsr_results['size'] = temp_hash.count
# list stop of routes
bsr_results['routes'] = temp_hash

## BAD REPO (SAD)
bad_request = motc_api_path('Tokyo')
bsr_response[bad_request] = call_motc_url(auth_code, xdate, bad_request)
bsr_response[bad_request].parse

File.write('spec/fixtures/bsr_response.yml', bsr_response.to_yaml)
File.write('spec/fixtures/bsr_results.yml', bsr_results.to_yaml)
