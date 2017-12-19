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
        routing.on 'coordinates', String, String do |start_l, end_l|
          directions = TaiGo::GoogleMapDirection.call(
            start: start_l.to_s,
            end: end_l.to_s)
          # puts directions.value.values[0]
          PossibleWaysRepresenter.new(PossibleWays.new(directions.value.values[0])).to_json
=begin
          possible_sub_routes = FindPossibleSubRoutesV2.new.call(
            s_lat: start_lat,
            s_lng: start_lng,
            d_lat: dest_lat,
            d_lng: dest_lng
          )
          final = possible_sub_routes.value.values
          puts final[0]
          psrs = Entity::PossibleSubRoutes.new(
            sub_route_set: final[0]
          )
          TaiGo::PossibleSubRoutesRepresenter.new(psrs).to_json
=end
        end
      end
    end
  end
end
