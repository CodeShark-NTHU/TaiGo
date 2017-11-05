# frozen_string_literal: false

require_relative 'spec_helper.rb'
require 'econfig'

describe 'Tests Bus Stop library' do
  extend Econfig::Shortcut
  Econfig.env = 'development'.to_s
  Econfig.root = '.'

  MOTC_ID = config['motc_id']
  MOTC_KEY = config['motc_key']
  CORRECT_ROUTE = YAML.safe_load(File.read('spec/fixtures/br_results.yml'))

  CASSETTE_FILE = 'motc_route_api'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'City information' do
    it 'HAPPY: should provide the correct number of bus route' do
      api = TaiGo::MOTC::Api.new(MOTC_ID, MOTC_KEY)
      broute_mapper = TaiGo::MOTC::BusRouteMapper.new(api)
      broute = broute_mapper.load(CITY_NAME)
      _(broute.size).must_equal CORRECT_ROUTE['size']
    end

    it 'SAD: it should throw a server error message' do
      proc do
        api = TaiGo::MOTC::Api.new(MOTC_ID, MOTC_KEY)
        broute_mapper = TaiGo::MOTC::BusRouteMapper.new(api)
        broute_mapper.load('Tokyo')
      end.must_raise TaiGo::MOTC::Api::Errors::ServerError
    end
  end

  describe 'Bus Route information' do
    before do
      api = TaiGo::MOTC::Api.new(MOTC_ID, MOTC_KEY)
      broute_mapper = TaiGo::MOTC::BusRouteMapper.new(api)
      @route = broute_mapper.load(CITY_NAME)
    end

    it 'HAPPY: should identify bus Stop ' do
      _(@route.count).must_equal CORRECT_ROUTE['routes'].count

      uid = @route.map(&:route_uid)
      correct_uid = CORRECT_ROUTE['routes'].map { |c| c['RouteUID'] }
      _(uid).must_equal correct_uid
    end
  end
end
