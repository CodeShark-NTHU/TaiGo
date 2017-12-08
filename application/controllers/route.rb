# frozen_string_literal: true

module TaiGo
  # Web API
  class Api < Roda
    plugin :all_verbs

    route('route') do |routing|
      # #{API_ROOT}/route index request
      routing.is do
        routing.get do
          message = 'API to get a specific route information'
          HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
        end
      end
      # '#{API_ROOT}/route/:route_id'
      routing.on String do |route_id|
        # GET '#{API_ROOT}/route/:route_id'
        routing.get do
          route = FindDatabaseRoute.call(
            route_id: route_id
          )
          http_response = HttpResponseRepresenter
                          .new(route.value)
          response.status = http_response.http_code
          if route.success?
            route = route.value.message
            BusRouteRepresenter.new(route).to_json
          else
            http_response.to_json
          end
        end
      end
    end
  end
end
