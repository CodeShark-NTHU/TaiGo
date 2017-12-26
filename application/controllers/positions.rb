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
          route_name.insert 1, '線' if name_zh[0] == '藍' && name_zh[2] == '區'
          route_name.concat('號') if name_zh[0..1] == '世博'
          positions = RealTimeFromMOTCPostionsOfSubRoute.call(
            city_name: city_name,
            route_name: route_name
          )
          BusPositionsRepresenter.new(Positions.new(positions.value.values[0])).to_json
        end
      end
    end
  end
end
