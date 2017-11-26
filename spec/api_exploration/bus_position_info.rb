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
  'http://ptx.transportdata.tw/MOTC/v2/Bus/RealTimeByFrequency/City/' + path
end

def call_motc_url(auth_code, date, url)
  HTTP.headers('x-date' => date, 'Authorization' => auth_code).get(url)
end

bp_response = {}
bp_results = {}

## GOOD REPO (HAPPY)
good_request = motc_api_path('Hsinchu/81')
bp_response[good_request] = call_motc_url(auth_code, xdate, good_request)
location = bp_response[good_request].parse

# should be 81
bp_results['RouteName'] = location[0]['RouteName']['Zh_tw']
# should provide all information about 2 bus that operated in route 81
bp_results['location'] = location

# BAD REPO (SAD)
bad_request = motc_api_path('Hsinchu/some_route')
bp_response[bad_request] = call_motc_url(auth_code, xdate, bad_request)
bp_response[bad_request].parse

File.write('spec/fixtures/bp_response.yml', bp_response.to_yaml)
File.write('spec/fixtures/bp_results.yml', bp_results.to_yaml)
