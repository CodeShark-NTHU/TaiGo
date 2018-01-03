# frozen_string_literal: true

require_relative 'coordinate_representer'
require_relative 'stops_of_route_representer'

module TaiGo
  # Representer class for converting BusDirectionRepresenter attributes to json
  class BusDirectionRepresenter < Roar::Decorator
    include Roar::JSON
    property :step_no
    property :bus_distance
    property :bus_duration
    collection :bus_path, extend: CoordinateRepresenter, class: OpenStruct
    property :bus_departure_time
    property :bus_departure_stop_name
    property :bus_arrival_time
    property :bus_arrival_stop_name
    property :bus_num_stops
    property :bus_sub_route_name
    collection :stops_of_sub_routes, extend: StopsOfSubRouteRepresenter, class: OpenStruct
  end
end
