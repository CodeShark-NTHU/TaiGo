# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find routes information from specific city
  # Usage:
  #   result = FindDatabaseRoutes.call(city_name: 'Hsinchu')
  #   result.success?
  module FindDatabaseRoutesByCity
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      routes = Repository::For[Entity::BusRoute]
               .find_city_name(input[:city_name])
      if routes.empty?
        message = "Couldn't find the routes from city #{input[:city_name]}"
        Left(Result.new(:not_found, message))
      else
        Right(Result.new(:ok, routes))
      end
    end
  end
end
