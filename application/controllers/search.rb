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
          directions = TaiGo::GoogleMapDirection.call(
            start_lat: start_lat,
            start_lng: start_lng,
            dest_lat: dest_lat,
            dest_lng: dest_lng)
          http_response = HttpResponseRepresenter.new(directions.value)
          response.status = http_response.http_code
          if directions.success?
            ds = directions.value.message
            combine = TaiGo::DumpStopsOfSubRoutes.new.call(gm_directions: ds)
            h_r_c = HttpResponseRepresenter.new(combine.value)
            response.status = h_r_c.http_code
            if combine.success?
              result = combine.value.message
              PossibleWaysRepresenter.new(PossibleWays.new(result)).to_json
            else
              h_r_c.to_json
            end
          else
            http_response.to_json
          end
        end
      end
    end
  end
end

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