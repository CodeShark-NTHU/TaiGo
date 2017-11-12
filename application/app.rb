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
              begin
                routes = TaiGo::MOTC::BusRouteMapper.new(app.config).load(city_name)
              rescue StandardError
                routing.halt(404, error: "Bus Routes at #{city_name} not found")
              end
              routes.map do |route|
                stored_routes = Repository::For[route.class].find_or_create(route)
                response.status = 201
                response['Location'] = "/api/v0.1/routes/#{city_name}"
                #stored_routes.to_h
                BusRouteRepresenter.new(stored_routes).to_json
              end
            end
          end

          # /api/v0.1/stops/:city_name
          routing.on 'stops', String do |city_name|
            # POST '/api/v0.1/stops/:city_name
            routing.post do
              begin
                stops = TaiGo::MOTC::BusStopMapper.new(app.config).load(city_name)
              rescue StandardError
                routing.halt(404, error: "Bus Stops at #{city_name} not found")
              end
              stops.map do |stop|
                stored_stops = Repository::For[stop.class].find_or_create(stop)
                response.status = 201
                response['Location'] = "/api/v0.1/stops/#{city_name}"
                #stored_stops.to_h
                BusStopRepresenter.new(stored_stops).to_json
              end
            end
          end

          # /api/v0.1/sub_routes/:city_name
          routing.on 'sub_routes', String do |city_name|
            # POST '/api/v0.1/sub_routes/:city_name
            routing.post do
              begin
                subroutes = TaiGo::MOTC::BusSubRouteMapper.new(app.config).load(city_name)
              rescue StandardError
                routing.halt(404, error: "Bus Sub Route at #{city_name} not found")
              end
              subroutes.map do |subroute|
                stored_sroutes = Repository::For[subroute.class].find_or_create(subroute)
                response.status = 201
                response['Location'] = "/api/v0.1/sub_routes/#{city_name}"
                #stored_sroutes.to_h
                SubRouteRepresenter.new(stored_sroutes).to_json
              end
            end
          end

          # # /api/v0.1/stop_of_routes/:city_name
          # routing.on 'stop_of_routes', String do |city_name|
          #   # GET /api/v0.1/routes/:name_ch
          #   # routing.get do
          #   #   route = Repository::For[Entity::BusRoute].find_name_ch(city_name)
          #   #   routing.halt(404, error: 'Route not found') unless route
          #   #   route.to_h
          #   # end

          #   # POST '/api/v0.1/stop_of_routes/:city_name
          #   routing.post do
          #     begin
          #       stop_of_routes = TaiGo::MOTC::StopOfRouteMapper.new(app.config).load(city_name)
          #     rescue StandardError
          #       routing.halt(404, error: "Bus Sub Route at #{city_name} not found")
          #     end
          #     stop_of_routes.map do |stopofroute|
          #       stored_stop_of_routes = Repository::For[stopofroute.class].find_or_create(stopofroute)
          #       response.status = 201
          #       response['Location'] = "/api/v0.1/stop_of_routes/#{city_name}"
          #       stored_stop_of_routes.to_h
          #     end
          #   end
          # end

          # /api/v0.1/stop_of_routes/:city_name
          routing.on 'stop_of_routes', String do |city_name|
            # POST '/api/v0.1/stop_of_routes/:city_name
            routing.post do
              begin
                stop_of_routes = TaiGo::MOTC::StopOfRouteMapper.new(app.config).load(city_name)
              rescue StandardError
                routing.halt(404, error: "Bus Sub Route at #{city_name} not found")
              end
              stop_of_routes.map do |stopofroute|
                stored_stop_of_routes = Repository::For[stopofroute.class].find_or_create(stopofroute)
                response.status = 201
                response['Location'] = "/api/v0.1/stop_of_routes/#{city_name}"
                #stored_stop_of_routes.to_h
                StopOfRouteRepresenter.new(stored_stop_of_routes).to_json
              end
            end
          end

          # /api/v0.1/stop_sequence/:sub_route_id
          routing.on 'stop_sequence', String do |sub_route_id|
            # GET /api/v0.1/stop_sequence/:sub_route_id
            routing.get do
              stop_sequences = Repository::For[Entity::StopOfRoute].find_all_stop_of_a_sub_route(sub_route_id)
              routing.halt(404, error: 'Sub Route not found') unless stop_sequences
              stop_sequences.map do |stop_sequence| # Not sure what this is - Reggie
                stop_sequence.to_h
              end
            end
          end
        end
      end
    end
  end
end
