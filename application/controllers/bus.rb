# frozen_string_literal: true

module TaiGo
  # Web API
  class Api < Roda
    plugin :all_verbs

    route('bus') do |routing|
      # #{API_ROOT}/bus index request
      routing.is do
        routing.get do
          message = 'API to get all the data of bus route or stops in a city'
          HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
        end
      end

      routing.on String do |city_name|
        # #{API_ROOT}/bus/:city_name/updates
        routing.on 'updates' do
          # GET '#{API_ROOT}/bus/:city_name/updates'
          routing.post do
            LoadFromMotcRoute.new.call(
              config: Api.config,
              city_name: city_name
            )
            LoadFromMotcStop.new.call(
              config: Api.config,
              city_name: city_name
            )
            LoadFromMotcStopOfRoute.new.call(
              config: Api.config,
              city_name: city_name
            )
            message = 'All Data has been updated'
            HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
          end
        end

        # #{API_ROOT}/bus/:city_name/routes
        routing.on 'routes' do
          # GET '#{API_ROOT}/bus/:city_name/routes'
          routing.get do
            routes = FindDatabaseRoutesByCity.call(
              city_name: city_name
            )
            http_response = HttpResponseRepresenter
                            .new(routes.value)
            response.status = http_response.http_code
            if routes.success?
              routes = routes.value.message
              BusRoutesRepresenter.new(Routes.new(routes)).to_json
            else
              http_response.to_json
            end
          end

          # POST '#{API_ROOT}/bus/city/:city_name/routes'
          routing.post do
            routes_service_result = LoadFromMotcRoute.new.call(
              config: Api.config,
              city_name: city_name
            )
            http_response = HttpResponseRepresenter
                            .new(routes_service_result.value)
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

        # #{API_ROOT}/bus/city/:city_name/stops
        routing.on 'stops' do
          # GET '{API_ROOT}/bus/:city_name/stops'
          routing.get do
            stops = Repository::For[Entity::BusStop].find_city_name(city_name)
            BusStopsRepresenter.new(Stops.new(stops)).to_json
          end
          # POST '#{API_ROOT}/stops/:city_name'
          routing.post do
            stops_service_result = LoadFromMotcStop.new.call(
              config: Api.config,
              city_name: city_name
            )
            http_response = HttpResponseRepresenter
                            .new(stops_service_result.value)
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

        # #{API_ROOT}/bus/city/:city_name/stop_of_routes
        routing.on 'stop_of_routes' do
          # POST '#{API_ROOT}/bus/city/:city_name/stop_of_routes
          routing.post do
            stop_of_routes_service_result = LoadFromMotcStopOfRoute.new.call(
              config: Api.config,
              city_name: city_name
            )
            http_response = HttpResponseRepresenter
                            .new(stop_of_routes_service_result.value)
            response.status = http_response.http_code
            if stop_of_routes_service_result.success?
              response['Location'] = "/api/v0.1/stop_of_routes/#{city_name}"
              stopofroutes = stop_of_routes_service_result.value.message
              StopOfRoutesRepresenter.new(Stopofroutes
                                      .new(stopofroutes)).to_json
            else
              http_response.to_json
            end
          end
        end
      end
    end
  end
end
