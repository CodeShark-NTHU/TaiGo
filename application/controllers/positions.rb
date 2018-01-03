# frozen_string_literal: true

module TaiGo
  # Web API
  class Api < Roda
    plugin :all_verbs

    route('positions') do |routing|
      # #{API_ROOT}/positions index request
      routing.is do
        routing.get do
          message = 'API to get the real time bus positions data'
          HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
        end
      end

      # {API_ROOT}/positions/:city_name/:route_name
      routing.on String, String do |city_name, route_name|
        # GET '{API_ROOT}/positions/:city_name/:route_name
        routing.get do
          # route_name.insert 1, '線' if route_name[0] == '藍' && route_name[2] == '區'
          # route_name.concat('號') if route_name[0..1] == '世博'
          positions = RealTimeFromMOTCPostionsOfSubRoute.call(
            city_name: city_name,
            route_name: route_name
          )
          http_response = HttpResponseRepresenter
                          .new(positions.value)
          response.status = http_response.http_code
          if positions.success?
            positions = positions.value.message
            BusPositionsRepresenter.new(Positions.new(positions)).to_json
          else
            http_response.to_json
          end
        end
      end
    end
  end
end
