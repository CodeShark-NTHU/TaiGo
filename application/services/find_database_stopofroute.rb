# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a collection of stops for a sub route from our database
  # Usage:
  #   result = FindDatabaseStopOfRoute.call(sub_route_id: 'HSZ000701')
  #   result.success?
  module FindDatabaseStopOfRoute
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      stops_of_a_route = Repository::For[Entity::StopOfRoute]
                         .find_all_stop_of_a_sub_route(input[:sub_route_id])
      if stops_of_a_route.empty?
        Left(Result.new(:not_found, "Could not find the stored stops (#{input[:sub_route_id]})"))
      else
        Right(Result.new(:ok, stops_of_a_route))
      end
    end
  end
end
