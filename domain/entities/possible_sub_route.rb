# frozen_string_literal: false

require 'dry-struct'
require_relative 'bus_stop.rb'
require_relative 'stops_of_sub_route.rb'

module TaiGo
  module Entity
    # Domain entity object for PossibleSubRoute
    class PossibleSubRoute < Dry::Struct
      attribute :start_stop, BusStop
      attribute :dest_stop, BusStop
      attribute :stops_of_sub_route, Types::Strict::Array.member(StopOfRoute)
    end
  end
end
