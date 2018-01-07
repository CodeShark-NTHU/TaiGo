# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a route information from our database
  # Usage:
  #   result = FindDatabaseStopOfRoute.call(sub_route_id: 'HSZ0007')
  #   result.success?
  module FindDatabaseRoute
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      route = Repository::For[Entity::BusRoute].find_id(input[:route_id])
      if route.nil?
        message = "Couldn't find the route ID #{input[:route_id]}"
        Left(Result.new(:not_found, message))
      else
        Right(Result.new(:ok, route))
      end
    end
  end
end
