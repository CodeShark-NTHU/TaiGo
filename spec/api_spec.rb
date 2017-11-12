# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests MOTC API library' do
  API_VER = 'api/v0.1'.freeze
  CASSETTE_FILE = 'taigo_api'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Bus Route Tests' do
    it 'HAPPY: it should return status 200 and data' do
      post "#{API_VER}/routes/#{CITY_NAME}"
      _(last_response.status).must_equal 201
      routes_data = JSON.parse last_response.body
      _(routes_data.size).must_be :>, 0
    end

    it 'SAD: should return a 404 not found error and must have error message' do
      post "#{API_VER}/routes/tokyo"
      _(last_response.status).must_equal 404
      body = JSON.parse last_response.body
      _(body.keys).must_include 'error'
    end
  end

  describe 'Bus Stop Tests' do
    it 'HAPPY: it should return status 200 and data' do
      post "#{API_VER}/stops/#{CITY_NAME}"
      _(last_response.status).must_equal 201
      routes_data = JSON.parse last_response.body
      _(routes_data.size).must_be :>, 0
    end

    it 'SAD: should return a 404 not found error and must have error message' do
      post "#{API_VER}/stops/tokyo"
      _(last_response.status).must_equal 404
      body = JSON.parse last_response.body
      _(body.keys).must_include 'error'
    end
  end

  describe 'Sub-Route Tests' do
    it 'HAPPY: it should return status 200 and data' do
      post "#{API_VER}/sub_routes/#{CITY_NAME}"
      _(last_response.status).must_equal 201
      routes_data = JSON.parse last_response.body
      _(routes_data.size).must_be :>, 0
    end

    it 'SAD: should return a 404 not found error and must have error message' do
      post "#{API_VER}/sub_routes/tokyo"
      _(last_response.status).must_equal 404
      body = JSON.parse last_response.body
      _(body.keys).must_include 'error'
    end
  end


   describe 'Stop of Routes Tests' do
    it 'HAPPY: it should return status 200 and data' do
      post "#{API_VER}/stop_of_routes/#{CITY_NAME}"
      _(last_response.status).must_equal 201
      routes_data = JSON.parse last_response.body
      _(routes_data.size).must_be :>, 0
    end

    it 'SAD: should return a 404 not found error and must have error message' do
      post "#{API_VER}/stop_of_routes/tokyo"
      _(last_response.status).must_equal 404
      body = JSON.parse last_response.body
      _(body.keys).must_include 'error'
    end
  end

  
end
