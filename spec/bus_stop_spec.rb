# frozen_string_literal: false

require_relative 'spec_helper.rb'
require 'econfig'

describe 'Tests Bus Stop library' do
  extend Econfig::Shortcut
  Econfig.env = 'development'.to_s
  Econfig.root = '.'

  CORRECT_STOP = YAML.safe_load(File.read('spec/fixtures/bs_results.yml'))

  CASSETTE_FILE = 'motc_stop_api'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri]
  end

  after do
    VCR.eject_cassette
  end

  describe 'City information' do
    it 'HAPPY: should provide the correct number of bus stops' do
      bstop_mapper = TaiGo::MOTC::BusStopMapper.new(app.config)
      bstop = bstop_mapper.load(CITY_NAME)
      _(bstop.size).must_equal CORRECT_STOP['size']
    end

    it 'SAD: it should throw a server error message' do
      proc do
        bstop_mapper = TaiGo::MOTC::BusStopMapper.new(app.config)
        bstop_mapper.load('Tokyo')
      end.must_raise TaiGo::MOTC::Api::Errors::ServerError
    end
  end

  describe 'Bus Stop information' do
    before do
      bstop_mapper = TaiGo::MOTC::BusStopMapper.new(app.config)
      @stops = bstop_mapper.load(CITY_NAME)
    end

    it 'HAPPY: should identify bus Stop ' do
      _(@stops.count).must_equal CORRECT_STOP['stops'].count

      id = @stops.map(&:id)
      correct_uid = CORRECT_STOP['stops'].map { |c| c['StopUID'] }
      _(id).must_equal correct_uid
    end
  end
end
