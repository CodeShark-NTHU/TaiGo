# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a collection of sub_routes that passing specific stop
  # Usage:
  #   result = FindDatabaseSubRouteOfAStop.call(stop_id: 'HSZ222237')
  #   result.success?
  module FindDatabaseSubRouteOfAStop
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      sub_routes_of_a_stop = Repository::For[Entity::StopOfRoute]
                             .find_stop_id(input[:stop_id])
      if sub_routes_of_a_stop.empty?
        message = "Couldn't find the sub routes for stopsID: #{input[:stop_id]}"
        Left(Result.new(:not_found, message))
      else
        Right(Result.new(:ok, sub_routes_of_a_stop))
      end
    end
  end
end
