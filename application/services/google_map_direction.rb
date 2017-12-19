# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a collection of all stops from our database
  # Usage:
  #   result = FindDatabaseAllOfStop.call()
  #   result.success?
  module GoogleMapDirection
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      direction_mapper = TaiGo::GoogleMap::DirectionMapper.new(Api.config)
      # directions = direction_mapper.load(input[:start], input[:end])
      directions = direction_mapper.load("新竹火車站(中正路) 300新竹市東區", "300新竹市東區光復路二段101號")
      Right(directions: directions)
    # rescue StandardError
    #   Left(Result.new(:not_found, 'directions not found'))
    end
  end
end
