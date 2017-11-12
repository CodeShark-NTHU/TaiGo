# frozen_string_literal: true

# require 'dry-monads'

module TaiGo
  # Service to find a collection of stops for a sub route from our database
  # Usage:
  #   result = FindDatabaseStopOfRoute.call(routeId: 'HSZ0007')
  #   result.success?
  module FindDatabaseRepo
    # extend Dry::Monads::Either::Mixin

    def self.call(input)
      stop_sequences = Repository::For[Entity::StopOfRoute]
                       .find_all_stop_of_a_sub_route(input[:sub_route_id])
      stop_sequences
    end
  end
end
