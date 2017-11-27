# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a collection of all stops from our database
  # Usage:
  #   result = FindDatabaseAllOfStop.call()
  #   result.success?
  module FindDatabaseAllOfStops
    extend Dry::Monads::Either::Mixin

    def self.call
      stops = Repository::For[Entity::BusStop].all
      if stops.empty?
        Left(Result.new(:not_found, "there are not stops in db."))
      else
        Right(Result.new(:ok, stops))
      end
    end
  end
end
