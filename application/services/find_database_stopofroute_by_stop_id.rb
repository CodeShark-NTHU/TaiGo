# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a collection of all stops from our database
  # Usage:
  #   result = FindDatabaseAllOfStop.call()
  #   result.success?
  module FindDatabaseStopOfRouteByStopID
    extend Dry::Monads::Either::Mixin

    def self.call(stop)
      # stop_of_route = Repository::For[Entity::StopOfRoute].find_all_stop_of_a_sub_route_which_include_this_stop(stop.id)
      stop_of_route = Repository::For[Entity::StopOfRoute].find_stop_id(stop.id)
      if stop_of_route.empty?
        Left(Result.new(:not_found, "no stop_of_route for this stop."))
      else
        Right(Result.new(:ok, stop_of_route))
      end
    end
  end
end
