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
      # stops_of_a_route = Repository::For[Entity::StopOfRoute]
      #                    .find_all_stop_of_a_sub_route(input[:sub_route_id])
      if route.nil?
        Left(Result.new(:not_found, "Couldn't find the route ID #{input[:route_id]}"))
      else
        Right(Result.new(:ok, route))
      end
    end
  end
end
