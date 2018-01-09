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
        # GET '{API_ROOT}/positions/:city_name/:route_name'
        request_id = [route_name.to_s, Time.now.to_f].hash.to_s
        routing.get do
          m = RealTimeBusPositions.new.call(
            config: Api.config,
            city_name: city_name,
            route_name: route_name,
            id: request_id
          )
          http_response = HttpResponseRepresenter
                          .new(m.value)
          response.status = http_response.http_code
          http_response.to_json
        end
      end
    end
  end
end
