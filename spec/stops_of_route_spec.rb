# frozen_string_literal: false

require_relative 'spec_helper.rb'
require 'econfig'

describe 'Tests Stops of route' do
  extend Econfig::Shortcut
  Econfig.env = 'development'.to_s
  Econfig.root = '.'

  MOTC_ID = config['motc_id']
  MOTC_KEY = config['motc_key']
  CORRECT = YAML.safe_load(File.read('spec/fixtures/sor_results.yml'))
  CORRECT_ROUTE = YAML.safe_load(File.read('spec/fixtures/sor_results.yml'))

  CASSETTE_FILE = 'motc_sor_api'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Number of Stops in specific Route information' do
    it 'HAPPY: should provide the correct number of bus stops of the route' do
      api = TaiGo::MOTC::Api.new(MOTC_ID, MOTC_KEY)
      stops_of_route_mapper = TaiGo::MOTC::StopOfRouteMapper.new(api)
      stops_of_route = stops_of_route_mapper.load(CITY_NAME)
      _(stops_of_route.size).must_equal CORRECT['size']
    end
  end
end
