# frozen_string_literal: true

module TaiGo
  # Web API
  class Api < Roda
    plugin :all_verbs

    route('sub_route') do |routing|
      # #{API_ROOT}/route index request
      routing.is do
        routing.get do
          message = 'API to get a specific route information'
          HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
        end
      end

      # #{API_ROOT}/sub_route/:sub_route_id
      routing.on String do |sub_route_id|
        # GET '#{API_ROOT}/sub_route/:sub_route_id/stops'
        routing.on 'stops' do
          routing.get do
            stops_of_a_sub_route = FindDatabaseStopOfRoute.call(
              sub_route_id: sub_route_id
            )
            http_response = HttpResponseRepresenter
                            .new(stops_of_a_sub_route.value)
            response.status = http_response.http_code
            if stops_of_a_sub_route.success?
              stop_of_routes = stops_of_a_sub_route.value.message
              StopOfRoutesRepresenter.new(Stopofroutes
                                     .new(stop_of_routes)).to_json
            else
              http_response.to_json
            end
          end
        end
        # GET '#{API_ROOT}/sub_route/:sub_route_id'
        routing.get do
          sub_route = Repository::For[Entity::BusSubRoute].find_id(sub_route_id)
          SubRouteRepresenter.new(sub_route).to_json
        end
      end
    end
  end
end
