# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests Bus Stop library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'City information' do
    it 'HAPPY: should provide the correct number of bus stops' do
      city_stops = PublicTransportation::MotcAPI.new.city_bus_stops(CITY_NAME)
      _(city_stops.size).must_equal CORRECT['size']
    end

    it 'SAD: it should throw a server error message' do
      proc do
        PublicTransportation::MotcAPI.new.city_bus_stops('Tokyo')
      end.must_raise PublicTransportation::Errors::ServerError
    end
  end

  describe 'Bus Stop information' do
    before do
      @stops = PublicTransportation::MotcAPI.new.city_bus_stops(CITY_NAME)
    end

    it 'HAPPY: should provided correct bus stop list' do
      # stops = @city.bus_stops
      _(@stops.count).must_equal CORRECT['stops'].count

      uid = @stops.map(&:uid)
      correct_uid = CORRECT['stops'].map { |c| c['StopUID'] }
      _(uid).must_equal correct_uid

      authority_id = @stops.map(&:authority_id)
      correct_authority_id = CORRECT['stops'].map { |c| c['AuthorityID'] }
      _(authority_id).must_equal correct_authority_id

      stop_name_ch = @stops.map(&:stop_name_ch)
      correct_stop_name_ch = CORRECT['stops'].map { |c| c['StopName']['Zh_tw'] }
      _(stop_name_ch).must_equal correct_stop_name_ch

      stop_name_en = @stops.map(&:stop_name_en)
      correct_stop_name_en = CORRECT['stops'].map { |c| c['StopName']['En'] }
      _(stop_name_en).must_equal correct_stop_name_en

      stop_longitude = @stops.map(&:stop_longitude)
      correct_stop_longitude = CORRECT['stops'].map { |c| c['StopPosition']['PositionLon'] }
      _(stop_longitude).must_equal correct_stop_longitude

      stop_latitude = @stops.map(&:stop_latitude)
      correct_stop_latitude = CORRECT['stops'].map { |c| c['StopPosition']['PositionLat'] }
      _(stop_latitude).must_equal correct_stop_latitude

      stop_address = @stops.map(&:stop_address)
      correct_stop_address = CORRECT['stops'].map { |c| c['StopAddress'] }
      _(stop_address).must_equal correct_stop_address
    end
  end
end
