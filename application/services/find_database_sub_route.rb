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
      sub_route = Repository::For[Entity::BusSubRoute].find_id(input[:sub_route_id])
      # stops_of_a_route = Repository::For[Entity::StopOfRoute]
      #                    .find_all_stop_of_a_sub_route(input[:sub_route_id])
      if sub_route.nil?
        Left(Result.new(:not_found, "Couldn't find the sub_route #{input[:sub_route_id]}"))
      else
        Right(Result.new(:ok, sub_route))
      end
    end
  end
end
