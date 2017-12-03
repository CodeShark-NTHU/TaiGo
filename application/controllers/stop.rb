# frozen_string_literal: true

module TaiGo
  # Web API
  class Api < Roda
    plugin :all_verbs

    route('stop') do |routing|
      # '#{API_ROOT}/stop' index request
      routing.is do
        routing.get do
          message = 'API to get a specific stop information'
          HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
        end
      end

      # #{API_ROOT}/stop/:stop_id
      routing.on String do |stop_id|
        # GET '#{API_ROOT}/stop/:stop_id/sub_route'
        routing.on 'sub_route' do
          routing.get do
            sub_routes_of_a_stop = Repository::For[Entity::StopOfRoute]
                                   .find_stop_id(stop_id)
            StopOfRoutesRepresenter.new(Stopofroutes
                                   .new(sub_routes_of_a_stop)).to_json
          end
        end
        # GET '#{API_ROOT}/stop/:stop_id
        routing.get do
          stop = Repository::For[Entity::BusStop].find_id(stop_id)
          BusStopRepresenter.new(stop).to_json
        end
      end
    end
  end
end
