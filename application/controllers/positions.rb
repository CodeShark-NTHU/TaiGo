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
<<<<<<< HEAD
          request_id = '5000'
=======
          #o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
          #request_id = (0...10).map { o[rand(o.length)] }.join
          #request_id = (Time.now.to_f).to_s
          request_id = "6000"
>>>>>>> 8ec53837f9be1bd18d491b758ff7e3f67c59005e
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
