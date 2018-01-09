# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to combine Google map direction with MOTC
  class RealTimeBusPositions
    include Dry::Transaction

    step :get_bus_position

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
