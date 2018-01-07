# frozen_string_literal: false

require_relative 'spec_helper.rb'
require 'econfig'

describe 'Tests Google Map Direction library' do
  extend Econfig::Shortcut
  Econfig.env = 'development'.to_s
  Econfig.root = '.'

  CORRECT_GMD = YAML.safe_load(File.read('spec/fixtures/gmd_results.yml'))

  CASSETTE_FILE = 'google_map_direction_api'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Direction info' do
    it 'HAPPY: should provide the correct bus direction detail' do
      direction_mapper = TaiGo::GoogleMap::DirectionMapper.new(app.config)
      dmpr = direction_mapper.load(START_LOCATION, END_LOCATION)
      _(dmpr.size).must_be :>=, 0
    end
  end
end
