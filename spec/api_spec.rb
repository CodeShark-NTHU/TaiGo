# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests MOTC API library' do
  API_VER = 'api/v0.1'.freeze
  CASSETTE_FILE = 'taigo_api'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri]
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

    describe 'POSTing to create routes entities from MOTC' do
      it 'HAPPY: should retrieve bus position info' do
        get "#{API_VER}/positions/#{CITY_NAME}/#{ROUTE_NAME}"
        _(last_response.status).must_equal 200
        position_data = JSON.parse last_response.body
        _(position_data.count).must_be :>, 0
      end

      it 'HAPPY: should retrieve and store routes' do
        post "#{API_VER}/bus/#{CITY_NAME}/routes"
        _(last_response.status).must_equal 201
        _(last_response.header['Location'].size).must_be :>, 0
        repo_data = JSON.parse last_response.body
        _(repo_data.size).must_be :>, 0
      end

      it 'SAD: should report error if no routes found' do
        post "#{API_VER}/bus/sad_city_name/routes"
        _(last_response.status).must_equal 404
      end

      it 'BAD: should report error if duplicate routes' do
        post "#{API_VER}/bus/#{CITY_NAME}/routes"
        _(last_response.status).must_equal 201
        post "#{API_VER}/bus/#{CITY_NAME}/routes"
        _(last_response.status).must_equal 409
      end
    end

    describe 'POSTing to create stops entities from MOTC' do
      it 'HAPPY: should retrieve and store stops' do
        post "#{API_VER}/bus/#{CITY_NAME}/stops"
        _(last_response.status).must_equal 201
        _(last_response.header['Location'].size).must_be :>, 0
        repo_data = JSON.parse last_response.body
        _(repo_data.size).must_be :>, 0
      end

      it 'SAD: should report error if no stps found' do
        post "#{API_VER}/bus/sad_city_name/stops"
        _(last_response.status).must_equal 404
      end

      it 'BAD: should report error if duplicate stps found' do
        post "#{API_VER}/bus/#{CITY_NAME}/stops"
        _(last_response.status).must_equal 201
        post "#{API_VER}/bus/#{CITY_NAME}/stops"
        _(last_response.status).must_equal 409
      end
    end

    describe 'POSTing to create stop_of_routes entities from MOTC' do
      before do
        post "#{API_VER}/bus/#{CITY_NAME}/stops"
        post "#{API_VER}/bus/#{CITY_NAME}/routes"
      end

      it 'HAPPY: should retrieve and stop_of_route' do
        post "#{API_VER}/bus/#{CITY_NAME}/stop_of_routes"
        _(last_response.status).must_equal 201
        _(last_response.header['Location'].size).must_be :>, 0
        repo_data = JSON.parse last_response.body
        _(repo_data.size).must_be :>, 0
      end

      it 'SAD: should report error if no stop_of_routes found' do
        post "#{API_VER}/bus/sad_city_name/stop_of_routes"
        _(last_response.status).must_equal 404
      end

      it 'BAD: should report error if duplicate stop_of_route found' do
        post "#{API_VER}/bus/#{CITY_NAME}/stop_of_routes"
        _(last_response.status).must_equal 201
        post "#{API_VER}/bus/#{CITY_NAME}/stop_of_routes"
        _(last_response.status).must_equal 409
      end
    end

    describe 'GETing database stop_of_route entities' do
      before do
        post "#{API_VER}/bus/#{CITY_NAME}/stops"
        post "#{API_VER}/bus/#{CITY_NAME}/routes"
        post "#{API_VER}/bus/#{CITY_NAME}/stop_of_routes"
      end

      it 'HAPPY: should find stored stop_of_route sequence list' do
        get "#{API_VER}/sub_route/#{SUB_ROUTE_ID}/stops"
        _(last_response.status).must_equal 200
        stop_of_routes_data = JSON.parse last_response.body
        _(stop_of_routes_data.size).must_be :>, 0
      end

      it 'SAD: should report error if no database stop_of_route entity found' do
        get "#{API_VER}/sub_route/not_exist_id/stops"
        _(last_response.status).must_equal 404
      end
    end
  end
end
