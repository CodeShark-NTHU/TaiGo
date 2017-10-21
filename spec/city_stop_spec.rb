# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests Bus Stop library' do

  describe 'City information' do
    it 'HAPPY: should provide the correct number of bus stops' do
      city = PublicTransportation::MotcAPI.new(cache: RESPONSE).city_bus_stops(CITY_NAME)
      _(city.size).must_equal CORRECT['size']
    end

    it 'SAD: it should throw a server error message' do
      proc do
        PublicTransportation::MotcAPI.new(cache: RESPONSE).city_bus_stops('Tokyo')
      end.must_raise PublicTransportation::Errors::ServerError
    end
  end

  describe 'Bus Stop information' do
    before do
      @stops = PublicTransportation::MotcAPI.new(cache: RESPONSE).city_bus_stops(CITY_NAME)
    end

    it 'HAPPY: should provided bus stop list' do
      # stops = @city.bus_stops
      _(@stops.count).must_equal CORRECT['stops'].count

      uid = @stops.map(&:uid)
      correct_uid = CORRECT['stops'].map { |c| c['StopUID'] }
      _(uid).must_equal correct_uid
    end
  end
end
