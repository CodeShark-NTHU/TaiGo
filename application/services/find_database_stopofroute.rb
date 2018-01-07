# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a collection of stops for a sub route from our database
  # Usage:
  #   result = FindDatabaseSubRouteOfAStop.call(stop_id: 'HSZ222237')
  #   result.success?
  module FindDatabaseStopOfRoute
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      stops_of_a_route = Repository::For[Entity::StopOfRoute]
                         .find_all_stop_of_a_sub_route(input[:sub_route_id])
      if stops_of_a_route.empty?
        message = "Couldn't find the stops ID: #{input[:sub_route_id]}"
        Left(Result.new(:not_found, message))
      else
        Right(Result.new(:ok, stops_of_a_route))
      end
    end
  end
end
