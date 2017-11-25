# frozen_string_literal: false

require_relative 'spec_helper.rb'
require 'econfig'

describe 'Tests Bus Position library' do
  extend Econfig::Shortcut
  Econfig.env = 'development'.to_s
  Econfig.root = '.'

  CORRECT_STOP = YAML.safe_load(File.read('spec/fixtures/bp_results.yml'))

  CASSETTE_FILE = 'motc_bus_position_api'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri]
  end

  after do
    VCR.eject_cassette
  end

  describe 'City information' do
    it 'HAPPY: should provide the correct bus_route' do
      bpos_mapper = TaiGo::MOTC::BusPositionMapper.new(app.config)
      bpos = bpos_mapper.load(CITY_NAME, ROUTE_NAME)
      _(bpos.size).must_be :>, 0
    end

    it 'SAD: it should throw a server error message' do
      bpos_mapper = TaiGo::MOTC::BusPositionMapper.new(app.config)
      bpos = bpos_mapper.load('Hsinchu', 'some_route')
      _(bpos.size).must_be :<, 1
    end
  end

  # describe 'Bus Position information' do
  #   before do
  #     bpos_mapper = TaiGo::MOTC::BusPositionMapper.new(app.config)
  #     @pos = bpos_mapper.load(CITY_NAME, ROUTE_NAME)
  #   end

  #   it 'HAPPY: should identify bus Stop ' do
  #     _(@pos.count).must_equal CORRECT_STOP['location'].count

  #     id = @pos.map(&:sub_route_id)
  #     correct_id = CORRECT_STOP['location'].map { |c| c['SubRouteUID'] }
  #     _(id).must_equal correct_id
  #   end
  # end
end
