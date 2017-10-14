require 'http'
require 'yaml'

# ga perlu credential
# config = YAML.safe_load(File.read('config/secrets.yml'))

def gh_api_path(path)
  'http://ptx.transportdata.tw/MOTC/v2/Bus/Route/City/' + path
end

def call_gh_url(url)
  HTTP.get(url)
end

br_response = {}
br_results = {}

## GOOD REPO (HAPPY)
repo_url = gh_api_path('Hsinchu')
br_response[repo_url] = call_gh_url(repo_url)
routes = br_response[repo_url].parse

br_results['routes'] = routes.count
# should be 28

br_results['routes'] = routes

## BAD REPO (SAD)
bad_repo_url = gh_api_path('Taiwan')
br_response[bad_repo_url] = call_gh_url(bad_repo_url)
br_response[bad_repo_url].parse # makes sure any streaming finishes

File.write('spec/fixtures/br_response.yml', br_response.to_yaml)
File.write('spec/fixtures/br_results.yml', br_results.to_yaml)
