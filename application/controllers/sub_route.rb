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

      # #{API_ROOT}/sub_route/:sub_route_id
      routing.on 'sub_route', String do |sub_route_id|
        # GET #{API_ROOT}/sub_route/:sub_route_id/stops
        routing.on 'stops' do
          routing.get do
            stops_of_a_sub_route = Repository::For[Entity::StopOfRoute]
                                   .find_all_stop_of_a_sub_route(sub_route_id)
            StopOfRoutesRepresenter.new(Stopofroutes
                                   .new(stops_of_a_sub_route)).to_json
          end
        end
        # GET #{API_ROOT}/sub_route/:sub_route_id
        routing.get do
          sub_route = Repository::For[Entity::BusSubRoute].find_id(sub_route_id)
          SubRouteRepresenter.new(sub_route).to_json
        end
      end
    end
  end
end
