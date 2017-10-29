# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests Praise library' do
  API_VER = 'api/v0.1'.freeze
  CASSETTE_FILE = 'codepraise_api'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Repo information' do
    it 'HAPPY: should provide correct repo attributes' do
      get "#{API_VER}/repo/#{USERNAME}/#{REPO_NAME}"
      _(last_response.status).must_equal 200
      repo_data = JSON.parse last_response.body
      _(repo_data.size).must_be :>, 0
    end

    it 'SAD: should raise exception on incorrect repo' do
      get "#{API_VER}/repo/#{USERNAME}/bad_repo"
      _(last_response.status).must_equal 404
      body = JSON.parse last_response.body
      _(body.keys).must_include 'error'
    end
  end
end
