# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a collection of all stops from our database
  # Usage:
  #   result = FindDatabaseAllOfStop.call()
  #   result.success?
  module RealTimeFromMOTCPostionsOfSubRoute
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      # bpos_mapper = TaiGo::MOTC::BusPositionMapper.new(Api.config)
      # positions = bpos_mapper.load(input[:city_name], input[:route_name])
      real_time_bus_request = real_time_bus_request_json(input)
      RealTimeBusWorker.perform_async(real_time_bus_request.to_json)
      if positions.empty?
        Left(Result.new(:not_found, 'positions not found'))
      else
        Left(Result.new(:processing, { id: input[:id] }))
        # Right(Result.new(:ok, positions))
        # Right(positions: positions)
      end
    end

    private

    def real_time_bus_request_json(input)
      real_time_bus_request = RealTimeBusRequest.new(input[:city_name], input[:route_name], input[:id])
      RealTimeBusRequestRepresenter.new(real_time_bus_request)
    end
  end
end
