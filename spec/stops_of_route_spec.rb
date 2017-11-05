# frozen_string_literal: false

require_relative 'spec_helper.rb'
require 'econfig'

describe 'Tests Stops of route' do
  extend Econfig::Shortcut
  Econfig.env = 'development'.to_s
  Econfig.root = '.'

  MOTC_ID = config['motc_id']
  MOTC_KEY = config['motc_key']

  CORRECT_SOR = YAML.safe_load(File.read('spec/fixtures/sor_results.yml'))

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
      _(stops_of_route.size).must_equal CORRECT_SOR['size']
    end

    it 'SAD: it should throw a server error message' do
      proc do
        api = TaiGo::MOTC::Api.new(MOTC_ID, MOTC_KEY)
        stops_of_route_mapper = TaiGo::MOTC::StopOfRouteMapper.new(api)
        stops_of_route_mapper.load('Tokyo')
      end.must_raise TaiGo::MOTC::Api::Errors::ServerError
    end

    describe 'Bus Stop information' do
      before do
        api = TaiGo::MOTC::Api.new(MOTC_ID, MOTC_KEY)
        stops_of_route_mapper = TaiGo::MOTC::StopOfRouteMapper.new(api)
        @sor = stops_of_route_mapper.load(CITY_NAME)
      end

      it 'HAPPY: should identify list of stop of routes combination' do
        _(@sor.count).must_equal CORRECT_SOR['stops'].count

        route_uid = @sor.map(&:route_uid)
        correct_uid = CORRECT_SOR['stops'].map { |c| c['RouteUID'] }
        _(route_uid).must_equal correct_uid
      end
    end
  end
end
