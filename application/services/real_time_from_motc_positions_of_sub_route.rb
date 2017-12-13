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
      bpos_mapper = TaiGo::MOTC::BusPositionMapper.new(Api.config)
      positions = bpos_mapper.load(input[:city_name], input[:route_name])
      Right(positions: positions)
    rescue StandardError
      Left(Result.new(:not_found, 'positions not found'))
    end  
  end
end
