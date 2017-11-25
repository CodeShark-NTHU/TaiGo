# frozen_string_literal: false

require 'dry-struct'
require_relative 'bus_stop.rb'
# require_relative 'bus_sub_route.rb'

module TaiGo
  module Entity
    # Domain entity object for Stop Of Route
    class StopOfRoute < Dry::Struct
      attribute :sub_route_id, Types::Strict::String
      attribute :stop_id, Types::Strict::String
      attribute :stop_boarding, Types::Strict::Int
      attribute :stop_sequence, Types::Strict::Int
      # attribute :sub_route, Types.Instance(BusSubRoute).optional
      attribute :stop, Types.Instance(BusStop).optional
    end
  end
end
