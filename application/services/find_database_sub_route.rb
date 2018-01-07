# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a sub route information from our database
  # Usage:
  #   result = FindDatabaseStopOfRoute.call(sub_route_id: 'HSZ000701')
  #   result.success?
  module FindDatabaseSubRoute
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      sub_route = Repository::For[Entity::BusSubRoute]
                  .find_id(input[:sub_route_id])
      if sub_route.nil?
        message = "Couldn't find the sub_route #{input[:sub_route_id]}"
        Left(Result.new(:not_found, message))
      else
        Right(Result.new(:ok, sub_route))
      end
    end
  end
end
