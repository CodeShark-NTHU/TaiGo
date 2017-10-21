# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/motc_api.rb'

describe 'Tests City Stop library' do
  CITY_NAME = 'Hsinchu'.freeze
  CORRECT = YAML.safe_load(File.read('spec/fixtures/bs_results.yml'))
  RESPONSE = YAML.load(File.read('spec/fixtures/bs_response.yml'))

  describe 'City information' do
    it 'HAPPY: should provide the correct number of bus stops' do
      city = PublicTransporation::MotcAPI.new(cache: RESPONSE).city_bus_stops(CITY_NAME)
      _(city.size).must_equal CORRECT['size']
    end

    it 'SAD: it should throw a server error message' do
      proc do
        PublicTransporation::MotcAPI.new(cache: RESPONSE).city_bus_stops('Tokyo')
      end.must_raise PublicTransporation::Errors::ServerError
    end
  end

  describe 'Bus Stop information' do
    before do
      @stops = PublicTransporation::MotcAPI.new(cache: RESPONSE).city_bus_stops(CITY_NAME)
    end

    it 'HAPPY: should provided bus stop list' do
      #stops = @city.bus_stops
      _(@stops.count).must_equal CORRECT['stops'].count

      uid = @stops.map(&:uid)
      correct_uid = CORRECT['stops'].map { |c| c['StopUID'] }
      _(uid).must_equal correct_uid
    end
  end
end
