# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to get the directions
  # Usage:
  #   result = GoogleMapDirection.call()
  #   result.success?
  module GoogleMapDirection
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      direction_mapper = TaiGo::GoogleMap::DirectionMapper.new(Api.config)
      start = "#{input[:start_lat]},#{input[:start_lng]}"
      dest = "#{input[:dest_lat]},#{input[:dest_lng]}"
      directions = direction_mapper.load(start, dest)
      Right(Result.new(:ok, directions))
    rescue StandardError
      Left(Result.new(:not_found, 'please open your internet'))
    end
  end
end