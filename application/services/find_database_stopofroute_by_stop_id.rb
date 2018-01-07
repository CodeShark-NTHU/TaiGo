# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a collection of stop of route that have stop_id from our database
  # Usage:
  #   result = FindDatabaseAllOfStop.call(stop_id: 'HSZ222237')
  #   result.success?
  module FindDatabaseStopOfRouteByStopID
    extend Dry::Monads::Either::Mixin

    def self.call(stop)
      stop_of_route = Repository::For[Entity::StopOfRoute].find_stop_id(stop.id)
      if stop_of_route.empty?
        message = 'stop_of_route were not found for this stop'
        Left(Result.new(:not_found, message))
      else
        Right(Result.new(:ok, stop_of_route))
      end
    end
  end
end
