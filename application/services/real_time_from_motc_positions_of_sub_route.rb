# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to combine Google map direction with MOTC
  class RealTimeBusPositions
    include Dry::Transaction

    step :creating_request_id
    step :get_bus_position

    def creating_request_id(input)
      route = Repository::For[Entity::BusRoute]
              .find_by_name_zh(input[:route_name])
      if route.nil?
        message = "Couldn't find the route #{input[:route_name]}"
        Left(Result.new(:not_found, message))
      else
        id = [route.id, Time.now].hash.to_s
        Right(id: id)
      end
    end

    def get_bus_position(input)
      real_time_bus_request = real_time_bus_request_json(input)
      RealTimeBusWorker.perform_async(real_time_bus_request.to_json)
      Right(Result.new(:processing, id: input[:id]))
    end

    private

    def real_time_bus_request_json(input)
      real_time_bus_request = RealTimeBusRequest.new(input[:city_name],
                                                     input[:route_name],
                                                     input[:id])
      RealTimeBusRequestRepresenter.new(real_time_bus_request)
    end
  end
end
