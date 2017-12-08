# frozen_string_literal: true

module TaiGo
  # Web API
  class Api < Roda
    plugin :all_verbs

    route('search') do |routing|
      # #{API_ROOT}/search index request
      routing.is do
        routing.get do
          message = 'API to get the best routes between start and dest'
          HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
        end
      end

      # #{API_ROOT}/search/stop/coordinates/:start_lat/:start_lng/:dest_lat/:dest_lng
      routing.on 'stop' do
        routing.on 'coordinates', String, String, String, String do |start_lat, start_lng, dest_lat, dest_lng|
          # GET '#{API_ROOT}/search/stop/coordinates/:start_lat/:start_lng/:dest_lat/:dest_lng'
          find_result = FindDatabaseAllOfStops.call
          routing.halt(404, 'There are no stops in db') if find_result.failure?
          @allofstops = find_result.value.message
          routing.get do
            dest = Entity::FindNearestStops.new(@allofstops)
            dest.initialize_location(dest_lat, dest_lng)
            nearest_stop = dest.find_nearest_stop
            pss = Entity::FindPossibleSubSubroutes.new(nearest_stop, start_lat, start_lng)
            TaiGo::PossibleSubRoutesRepresenter.new(pss.build_entity).to_json
          end
        end
      end
    end
  end
end
