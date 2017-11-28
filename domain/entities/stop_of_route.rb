# frozen_string_literal: false

require 'dry-struct'
require_relative 'bus_stop.rb'

module TaiGo
  module Entity
    # Domain entity object for StopOfRoute
    class StopOfRoute < Dry::Struct
      attribute :sub_route_id, Types::Strict::String
      attribute :stop_id, Types::Strict::String
      attribute :stop_boarding, Types::Strict::Int
      attribute :stop_sequence, Types::Strict::Int
      attribute :stop, Types.Instance(BusStop).optional
    end
  end
end
