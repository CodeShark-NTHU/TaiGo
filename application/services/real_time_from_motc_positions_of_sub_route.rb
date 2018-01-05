# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to combine Google map direction with MOTC
  class RealTimeBusPositions
    include Dry::Transaction

    step :get_bus_position

    def get_bus_position(input)
      # bpos_mapper = TaiGo::MOTC::BusPositionMapper.new(Api.config)
      # positions = bpos_mapper.load(input[:city_name], input[:route_name])
      real_time_bus_request = real_time_bus_request_json(input)
      r = RealTimeBusWorker.perform_async(real_time_bus_request.to_json)
      Right(Result.new(:processing, []))
      # if positions.empty?
      #   Left(Result.new(:not_found, 'positions not found'))
      # else
      #   Right(Result.new(:processing, positions))
      #   # Right(Result.new(:ok, positions))
      #   # Right(positions: positions)
      # end
    end

    private

    def real_time_bus_request_json(input)
      real_time_bus_request = RealTimeBusRequest.new(input[:city_name], input[:route_name], input[:id])
      RealTimeBusRequestRepresenter.new(real_time_bus_request)
    end
  end
end
