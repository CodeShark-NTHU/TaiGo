# frozen_string_literal: false

require 'dry-struct'

module TaiGo
  module Entity
    # Domain entity object for WalkingDirection
    class BusDirection < Dry::Struct
      attribute :step_no, Types::Strict::Int
      attribute :bus_distance, Types::Strict::String
      attribute :bus_duration, Types::Strict::String
      attribute :bus_path, Types::Strict::String
      attribute :bus_departure_time, Types::Strict::String
      attribute :bus_departure_stop_name, Types::Strict::String
      attribute :bus_arrival_time, Types::Strict::String
      attribute :bus_arrival_stop_name, Types::Strict::String
      attribute :bus_num_stops, Types::Strict::Int
      attribute :bus_sub_route_name, Types::Strict::String
    end
  end
end
