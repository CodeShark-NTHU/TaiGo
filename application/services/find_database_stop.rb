# frozen_string_literal: true

require 'dry-monads'

module TaiGo
  # Service to find a stop information from our database
  # Usage:
  #   result = FindDatabaseStop.call(stop_id: 'HSZ222237')
  #   result.success?
  module FindDatabaseStop
    extend Dry::Monads::Either::Mixin

    def self.call(input)
      stop = Repository::For[Entity::BusStop].find_id(input[:stop_id])
      if stop.nil?
        Left(Result.new(:not_found,
                        "Couldn't find the stops ID: #{input[:stop_id]}"))
      else
        Right(Result.new(:ok, stop))
      end
    end
  end
end
