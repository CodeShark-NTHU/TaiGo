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
      stops_of_route_mapper = TaiGo::MOTC::StopsOfRouteMapper.new(api)
      stops_of_route = stops_of_route_mapper.load(ROUTE_NAME)
      _(stops_of_route.size).must_equal CORRECT['size']
    end

   
    it 'SAD: it should throw a server error message' do
      proc do
        api = TaiGo::MOTC::Api.new(MOTC_ID, MOTC_KEY)
        stops_of_route_mapper = TaiGo::MOTC::StopsOfRouteMapper.new(api)
        stops_of_route_mapper.load('公車號碼')
      end.must_raise TaiGo::MOTC::Api::Errors::ServerError
    end

  end

  describe 'make sure route have the right bus stop information' do
    before do
      api = TaiGo::MOTC::Api.new(MOTC_ID, MOTC_KEY)
      stops_of_route_mapper = TaiGo::MOTC::StopsOfRouteMapper.new(api)
      @stops = stops_of_route_mapper.load(ROUTE_NAME)
    end

    it 'HAPPY: should identify bus Stop ' do
      _(@stops.count).must_equal CORRECT['stops'].count

      uid = @stops.map(&:uid)
      correct_uid = CORRECT['stops'].map { |c| c['StopUID'] }
      _(uid).must_equal correct_uid
    end
  end

end
