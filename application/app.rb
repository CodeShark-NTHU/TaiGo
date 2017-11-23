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

    route do |routing|
      app = Api

      # GET / request
      routing.root do
        { 'message' => "TaiGo API v0.1 up in #{app.environment} mode" }
      end

      routing.on 'api' do
        # /api/v0.1 branch
        routing.on 'v0.1' do
          # Future development
          # #/api/v0.1/:city_name
          # routing.on String do |city_name|
          #   #/api/v0.1/:city_name/sub_routes
          #   routing.on 'sub_routes' do
          #   end
          #   #/api/v0.1/:city_name/routes
          #   routing.on 'routes' do
          #   end
          # end
          # #/api/v0.1/:city_name
          # routing.on 'sub_route', String do |sub_id|
          #   #/api/v0.1/:city_name/sub_routes
          #   routing.get do
          #   end
          # end
          routing.on 'all_routes' do
            routing.get do
              routes = Repository::For[Entity::BusRoute].all
              BusRoutesRepresenter.new(Routes.new(routes)).to_json
            end
          end

          # /api/v0.1/positions/:city_name/:route_name
          routing.on 'positions', String do |city_name, route_name|
            # GET '/api/v0.1/positions/:city_name/:route_name
            routing.get do
              bpos_mapper = TaiGo::MOTC::BusPositionMapper.new(app.config)
              positions = bpos_mapper.load(city_name, route_name)              
              BusPositionsRepresenter.new(Positions.new(positions)).to_json
            end
          end

          # /api/v0.1/routes/:city_name
          routing.on 'routes', String do |city_name|
            # POST '/api/v0.1/routes/:city_name
            routing.post do
              routes_service_result = LoadFromMotcRoute.new.call(
                config: app.config,
                city_name: city_name
              )
              http_response = HttpResponseRepresenter.new(routes_service_result.value)
              response.status = http_response.http_code
              if routes_service_result.success?
                response['Location'] = "/api/v0.1/routes/#{city_name}"
                routes_service_result.value.message.map do |r|
                  BusRouteRepresenter.new(r).to_json
                end
              else
                http_response.to_json
              end
            end
          end

          # /api/v0.1/stops/:city_name
          routing.on 'stops', String do |city_name|
            # POST '/api/v0.1/stops/:city_name
            routing.post do
              stops_service_result = LoadFromMotcStop.new.call(
                config: app.config,
                city_name: city_name
              )
              http_response = HttpResponseRepresenter.new(stops_service_result.value) 
              response.status = http_response.http_code
              if stops_service_result.success?
                response['Location'] = "/api/v0.1/stops/#{city_name}"
                stops_service_result.value.message.map do |s|
                  BusStopRepresenter.new(s).to_json
                end
              else
                http_response.to_json
              end
            end
          end

          # /api/v0.1/sub_routes/:city_name
          routing.on 'sub_routes', String do |city_name|
            # POST '/api/v0.1/sub_routes/:city_name
            routing.post do
              subroute_service_result = LoadFromMotcSubRoute.new.call(
                config: app.config,
                city_name: city_name
              )
              http_response = HttpResponseRepresenter.new(subroute_service_result.value)
              response.status = http_response.http_code
              if subroute_service_result.success?
                response['Location'] = "/api/v0.1/sub_routes/#{city_name}"
                subroute_service_result.value.message.map do |sr|
                  SubRouteRepresenter.new(sr).to_json
                end
              else
                http_response.to_json
              end
            end
          end

          # /api/v0.1/stop_of_routes/:city_name
          routing.on 'stop_of_routes', String do |city_name|
            # POST '/api/v0.1/stop_of_routes/:city_name
            routing.post do
              stop_of_routes_service_result = LoadFromMotcStopOfRoute.new.call(
                config: app.config,
                city_name: city_name
              )
              http_response = HttpResponseRepresenter.new(stop_of_routes_service_result.value)
              response.status = http_response.http_code
              if stop_of_routes_service_result.success?
                response['Location'] = "/api/v0.1/stop_of_routes/#{city_name}"
                stop_of_routes_service_result.value.message.map do |sor|
                  StopOfRouteRepresenter.new(sor).to_json
                end
              else
                http_response.to_json
              end
            end
          end

          # /api/v0.1/stop_sequence/:sub_route_id
          routing.on 'stop_sequence', String do |sub_route_id|
            # GET /api/v0.1/stop_sequence/:sub_route_id
            routing.get do
              stops_of_a_route = FindDatabaseStopOfRoute.call(
                sub_route_id: sub_route_id
              )
              http_response = HttpResponseRepresenter.new(stops_of_a_route.value)
              response.status = http_response.http_code
              if stops_of_a_route.success?
                stops = stops_of_a_route.value.message
                stops.map do |stop|
                  StopOfRouteRepresenter.new(stop).to_json
                end
              else
                http_response.to_json
              end
            end
          end
        end
      end
    end
  end
end
