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
  'http://ptx.transportdata.tw/MOTC/v2/Bus/Stop/City/' + path
end

def call_motc_url(auth_code, date, url)
  HTTP.headers('x-date' => date, 'Authorization' => auth_code).get(url)
end

bs_response = {}
bs_results = {}

## GOOD REPO (HAPPY)
good_request = motc_api_path('Hsinchu')
bs_response[good_request] = call_motc_url(auth_code, xdate, good_request)
stops = bs_response[good_request].parse

# should be xxx bus stop in Hsinchu
bs_results['size'] = stops.count
# should be 12 (Hsinchu authority code)
bs_results['AuthorityID'] = stops[0]['AuthorityID']
# should provide all information about 956 bus stop
bs_results['stops'] = stops

## BAD REPO (SAD)
bad_request = motc_api_path('Tokyo')
bs_response[bad_request] = call_motc_url(auth_code, xdate, bad_request)
bs_response[bad_request].parse

File.write('spec/fixtures/bs_response.yml', bs_response.to_yaml)
File.write('spec/fixtures/bs_results.yml', bs_results.to_yaml)
