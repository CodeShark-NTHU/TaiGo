# frozen_string_literal: true

require 'roda'

module TaiGo
  # TaiGo Web API
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
          # /api/v0.1/:city_name
          routing.on 'bus', String do |city_name|
            # /api/v0.1/bus/:city_name/routes
            routing.on 'routes' do
              routing.get do
                routes = Repository::For[Entity::BusRoute].find_city_name(city_name)
                BusRoutesRepresenter.new(Routes.new(routes)).to_json
              end
            end
            # /api/v0.1/bus/:city_name/stops
            routing.on 'stops' do
              routing.get do
                stops = Repository::For[Entity::BusStop].find_city_name(city_name)
                BusStopsRepresenter.new(Stops.new(stops)).to_json
              end
            end
          end
          # /api/v0.1/bus/route/:route_id
          routing.on 'route', String do |route_id|
            # GET '/api/v0.1/route/:route_id
            routing.get do
              route = Repository::For[Entity::BusRoute].find_id(route_id)
              BusRouteRepresenter.new(route).to_json
            end
          end
          # /api/v0.1/stop/:stop_id
          routing.on 'stop', String do |stop_id|
            # GET '/api/v0.1/stop/:stop_id/sub_route
            routing.on 'sub_route' do
              routing.get do
                sub_routes_of_a_stop = Repository::For[Entity::StopOfRoute].find_stop_id(stop_id)
                StopOfRoutesRepresenter.new(Stopofroutes.new(sub_routes_of_a_stop)).to_json
              end
            end
            # GET '/api/v0.1/stop/:stop_id
            routing.get do
              stop = Repository::For[Entity::BusStop].find_id(stop_id)
              BusStopRepresenter.new(stop).to_json
            end
          end
          # /api/v0.1/sub_route/:sub_route_id
          routing.on 'sub_route', String do |sub_route_id|
            # GET '/api/v0.1/sub_route/:sub_route_id/stops
            routing.on 'stops' do
              routing.get do
                stops_of_a_sub_route = Repository::For[Entity::StopOfRoute]
                                       .find_all_stop_of_a_sub_route(sub_route_id)
                StopOfRoutesRepresenter.new(Stopofroutes.new(stops_of_a_sub_route)).to_json
              end
            end
            # GET '/api/v0.1/sub_route/:sub_route_id
            routing.get do
              sub_route = Repository::For[Entity::BusSubRoute].find_id(sub_route_id)
              SubRouteRepresenter.new(sub_route).to_json
            end
          end

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
              # puts positions
              BusPositionsRepresenter.new(Positions.new(positions)).to_json
            end
          end

          # /api/v0.1/search/stop/coordinates/:lat/:lng
          routing.on 'search' do
            routing.on 'stop' do
              routing.on 'coordinates', String do |lat, lng|
                # GET ' /api/v0.1/search/stop/coordinates/:lat/:lng'
                find_result = FindDatabaseAllOfStops.call
                routing.halt(404, 'There are no stops in db') if find_result.failure?
                @allofstops = find_result.value.message
                routing.get do
                  dest = Entity::FindNearestStops.new(@allofstops)
                  dest.initialize_dest(lat, lng)
                  nearest_stops = dest.find_nearest_stops()
                  
                  nearest_stops.map do |n_s|
                    FindDatabaseStopOfRouteByStopID.call(n_s).value.message.map do |s|
                    StopOfRoutesRepresenter.new(Stopofroutes.new(s)).to_json
                    end
                  end
                end
              end
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
                routes = routes_service_result.value.message
                BusRoutesRepresenter.new(Routes.new(routes)).to_json
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
                stops = stops_service_result.value.message
                BusStopsRepresenter.new(Stops.new(stops)).to_json
              else
                http_response.to_json
              end
            end
          end

          # # /api/v0.1/sub_routes/:city_name
          # routing.on 'sub_routes', String do |city_name|
          #   # POST '/api/v0.1/sub_routes/:city_name
          #   routing.post do
          #     subroute_service_result = LoadFromMotcSubRoute.new.call(
          #       config: app.config,
          #       city_name: city_name
          #     )
          #     http_response = HttpResponseRepresenter.new(subroute_service_result.value)
          #     response.status = http_response.http_code
          #     if subroute_service_result.success?
          #       response['Location'] = "/api/v0.1/sub_routes/#{city_name}"
          #       subroutes = subroute_service_result.value.message
          #       BusSubRoutesRepresenter.new(Subroutes.new(subroutes)).to_json
          #     else
          #       http_response.to_json
          #     end
          #   end
          # end

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
                stopofroutes = stop_of_routes_service_result.value.message
                StopOfRoutesRepresenter.new(Stopofroutes.new(stopofroutes)).to_json
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
                stopofroutes = stops_of_a_route.value.message
                StopOfRoutesRepresenter.new(Stopofroutes.new(stopofroutes)).to_json
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
