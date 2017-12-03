# frozen_string_literal: false

require 'dry-struct'
require_relative 'bus_stop.rb'
require_relative 'possible_sub_route.rb'

module TaiGo
  module Entity
    # Domain entity object for PossibleSubRoute
    class PossibleSubRoutes < Dry::Struct
      attribute :destination_stop, BusStop
      attribute :sub_route_set, Types::Strict::Array.member(PossibleSubRoute)
    end
  end
end
