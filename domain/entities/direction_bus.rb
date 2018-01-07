# frozen_string_literal: false

require 'dry-struct'
require_relative '../google_map_mapper/direction_mapper.rb'
require_relative 'stops_of_sub_route.rb'

module TaiGo
  module Entity
    # Domain entity object for WalkingDirection
    class BusDirection < Dry::Struct
      attribute :step_no, Types::Strict::Int
      attribute :bus_distance, Types::Strict::String
      attribute :bus_duration, Types::Strict::String
      attribute :bus_path, Types::Strict::Array.member(Types.Instance(TaiGo::GoogleMap::DirectionMapper::DataMapper::Coordinates))
      attribute :bus_departure_time, Types::Strict::String
      attribute :bus_departure_stop_name, Types::Strict::String
      attribute :bus_arrival_time, Types::Strict::String
      attribute :bus_arrival_stop_name, Types::Strict::String
      attribute :bus_num_stops, Types::Strict::Int
      attribute :bus_sub_route_name, Types::Strict::String
      attribute :sub_routes, Types::Strict::Array.member(StopsOfSubRoute).optional
    end
  end
end
