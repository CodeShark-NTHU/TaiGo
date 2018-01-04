# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a collection of stops for a sub route from our database
  # Usage:
  #   result = FindDatabaseStopOfRoute.call(sub_route_id: 'HSZ000701')
  #   result.success?
  module FindDatabaseStop
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      stop = Repository::For[Entity::BusStop].find_id(input[:stop_id])
      if stop.nil?
        Left(Result.new(:not_found,
                        "Couldn't find the stops ID: #{input[:stop_id]}"))
      else
        Right(Result.new(:ok, stop))
      end
    end
  end
end
