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
      api = TaiGo::MOTC::Api.new(AUTH_CODE, SIGN_DATE)
      bstop_mapper = TaiGo::MOTC::BusStopMapper.new(api)
      bstop = bstop_mapper.load(CITY_NAME)
      _(bstop.size).must_equal CORRECT['size']
    end
    it 'SAD: it should throw a server error message' do
      proc do
        api = TaiGo::MOTC::Api.new(AUTH_CODE, SIGN_DATE)
        bstop_mapper = TaiGo::MOTC::BusStopMapper.new(api)
        bstop_mapper.load('Tokyo')
      end.must_raise TaiGo::MOTC::Api::Errors::ServerError
    end
  end

  describe 'Bus Stop information' do
    before do
      api = TaiGo::MOTC::Api.new(AUTH_CODE, SIGN_DATE)
      bstop_mapper = TaiGo::MOTC::BusStopMapper.new(api)
      @stops = bstop_mapper.load(CITY_NAME)
    end

    it 'HAPPY: should identify contributors' do
      _(@stops.count).must_equal CORRECT['stops'].count

      uid = @stops.map(&:uid)
      correct_uid = CORRECT['stops'].map { |c| c['StopUID'] }
      _(uid).must_equal correct_uid
    end
  end
end
