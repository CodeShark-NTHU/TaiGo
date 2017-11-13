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
  
  describe 'MOTC information' do
    before do
      app.DB[:stop_of_routes].delete
      app.DB[:sub_routes].delete
      app.DB[:routes].delete
      app.DB[:stops].delete
    end

    describe 'POSTing to create entities from MOTC' do
      it 'HAPPY: should retrieve and store repo and collaborators' do
        post "#{API_VER}/routes/#{CITY_NAME}"
        _(last_response.status).must_equal 201
        _(last_response.header['Location'].size).must_be :>, 0
        repo_data = JSON.parse last_response.body
        _(repo_data.size).must_be :>, 0
      end

      it 'SAD: should report error if no routes found' do
        post "#{API_VER}/routes/sad_city_name"
        _(last_response.status).must_equal 404
      end

      it 'BAD: should report error if duplicate Github repo found' do
        post "#{API_VER}/routes/#{CITY_NAME}"
        _(last_response.status).must_equal 201
        post "#{API_VER}/routes/#{CITY_NAME}"
        _(last_response.status).must_equal 409
      end
    end

    describe 'GETing database entities' do
      before do
        TaiGo::FindDatabaseStopOfRoute.new.call(
          config: app.config,
          sub_route_id: SUB_ROUTE_ID
        )
      end

      it 'HAPPY: should find stored subroute sequence list' do
        get "#{API_VER}/stop_sequence/#{SUB_ROUTE_ID}"
        _(last_response.status).must_equal 200
        repo_data = JSON.parse last_response.body
        _(repo_data.size).must_be :>, 0
      end

      it 'SAD: should report error if no database repo entity found' do
        get "##{API_VER}/stop_sequence/not_exist_id"
        _(last_response.status).must_equal 404
      end
    end
  end

  
end
