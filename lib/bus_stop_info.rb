require 'http'
require 'yaml'

# ga perlu credential
# config = YAML.safe_load(File.read('config/secrets.yml'))

def gh_api_path(path)
  'http://ptx.transportdata.tw/MOTC/v2/Bus/Stop/City/' + path
end

def call_gh_url(url)
  HTTP.get(url)
end

bs_response = {}
bs_results = {}

## GOOD REPO (HAPPY)
repo_url = gh_api_path('Hsinchu')
bs_response[repo_url] = call_gh_url(repo_url)
stops = bs_response[repo_url].parse

bs_results['size'] = stops.count
# should be 30

bs_results['AuthorityID'] = stops[0]['AuthorityID']
# should have info about 12

bs_results['stops'] = stops

## BAD REPO (SAD)
bad_repo_url = gh_api_path('Taiwan')
bs_response[bad_repo_url] = call_gh_url(bad_repo_url)
bs_response[bad_repo_url].parse # makes sure any streaming finishes

File.write('spec/fixtures/bs_response.yml', bs_response.to_yaml)
File.write('spec/fixtures/bs_results.yml', bs_results.to_yaml)
