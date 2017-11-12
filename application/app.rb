# frozen_string_literal: true

require 'roda'
# require 'econfig'
# require_relative 'lib/init.rb'

module TaiGo
  # Web API
  class Api < Roda
    plugin :environments
    plugin :json
    plugin :halt

    # extend Econfig::Shortcut
    # Econfig.env = environment.to_s
    # Econfig.root = '.'

    route do |routing|
      app = Api
      # config = Api.config

      # GET / request
      routing.root do
        { 'message' => "TaiGo API v0.1 up in #{app.environment} mode" }
      end

      routing.on 'api' do
        # /api/v0.1 branch
        routing.on 'v0.1' do
          # /api/v0.1/routes/:city_name
          routing.on 'routes', String do |city_name|
            # POST '/api/v0.1/routes/:city_name
            routing.post do
              routes = LoadFromMotcRoute.call(
                config: app.config,
                city_name: city_name
              )
              routes.map do |route|
                stored_routes = Repository::For[route.class].find_or_create(route)
                response.status = 201
                response['Location'] = "/api/v0.1/routes/#{city_name}"
                BusRouteRepresenter.new(stored_routes).to_json
              end
            end
          end

          # /api/v0.1/stops/:city_name
          routing.on 'stops', String do |city_name|
            # POST '/api/v0.1/stops/:city_name
            routing.post do
              stops = LoadFromMotcStop.call(
                config: app.config,
                city_name: city_name
              )
              # it still wrong !!!!!! the way to present the result
              stops.map do |stop|
                stored_stops = Repository::For[stop.class].find_or_create(stop)
                response.status = 201
                response['Location'] = "/api/v0.1/stops/#{city_name}"
                BusStopRepresenter.new(stored_stops).to_json
              end
            end
          end

          # /api/v0.1/sub_routes/:city_name
          routing.on 'sub_routes', String do |city_name|
            # POST '/api/v0.1/sub_routes/:city_name
            routing.post do
              subroutes = LoadFromMotcSubRoute.call(
                config: app.config,
                city_name: city_name
              )
              # it still wrong !!!!!! the way to present the result
              subroutes.map do |subroute|
                stored_sroutes = Repository::For[subroute.class].find_or_create(subroute)
                response.status = 201
                response['Location'] = "/api/v0.1/sub_routes/#{city_name}"
                SubRouteRepresenter.new(stored_sroutes).to_json
              end
            end
          end

          # /api/v0.1/stop_of_routes/:city_name
          routing.on 'stop_of_routes', String do |city_name|
            # POST '/api/v0.1/stop_of_routes/:city_name
            routing.post do
              stop_of_routes = LoadFromMotcStopOfRoute.call(
                config: app.config,
                city_name: city_name
              )
              # it still wrong !!!!!! the way to present the result
              stop_of_routes.map do |stopofroute|
                stored_stop_of_routes = Repository::For[stopofroute.class].find_or_create(stopofroute)
                response.status = 201
                response['Location'] = "/api/v0.1/stop_of_routes/#{city_name}"
                StopOfRouteRepresenter.new(stored_stop_of_routes).to_json
              end
            end
          end

          # /api/v0.1/stop_sequence/:sub_route_id
          routing.on 'stop_sequence', String do |sub_route_id|
            # GET /api/v0.1/stop_sequence/:sub_route_id
            routing.get do
              stop_sequences = FindDatabaseRepo.call(
                sub_route_id: sub_route_id
              )
              routing.halt(404, error: 'Sub Route not found') unless stop_sequences
              # it still wrong !!!!!! the way to present the result
              stop_sequences.map do |stop_sequence|
                stop_sequence.to_h
              end
          end
          end
        end
      end
    end
  end
end
