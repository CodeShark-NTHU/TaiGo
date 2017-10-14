require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def gh_api_path(path)
  'https://api.github.com/repos/' + path
end

def call_gh_url(config, url)
  HTTP.headers(
    'Accept' => 'application/vnd.github.v3+json',
    'Authorization' => "token #{config['gh_token']}"
  ).get(url)
end

gh_response = {}
gh_results = {}

## GOOD REPO (HAPPY)
repo_url = gh_api_path('bhimasta/pinaple-sas')
gh_response[repo_url] = call_gh_url(config, repo_url)
repo = gh_response[repo_url].parse

gh_results['size'] = repo['size']
# should be 551

gh_results['owner'] = repo['owner']
# should have info about Bhimasta

gh_results['git_url'] = repo['git_url']
# should be "git://github.com/bhimasta/pinaple-sas"

gh_results['contributors_url'] = repo['contributors_url']
# "should be https://api.github.com/repos/bhimasta/pinaple-sas/contributors"

contributors_url = repo['contributors_url']
gh_response[contributors_url] = call_gh_url(config, contributors_url)
contributors = gh_response[contributors_url].parse

gh_results['contributors'] = contributors
contributors.count
# should be 3 contributors array

contributors.map { |c| c['login'] }
# should be ["albertusatria", "simoendem", "bhimasta"]

## BAD REPO (SAD)
bad_repo_url = gh_api_path('bhimasta/foobar')
gh_response[bad_repo_url] = call_gh_url(config, bad_repo_url)
gh_response[bad_repo_url].parse # makes sure any streaming finishes

File.write('spec/fixtures/gh_response.yml', gh_response.to_yaml)
File.write('spec/fixtures/gh_results.yml', gh_results.to_yaml)
