# frozen_string_literal: true

module TaiGo
  # Representer class for converting BusDirectionRepresenter attributes to json
  class BusDirectionRepresenter < Roar::Decorator
    include Roar::JSON
    property :step_no
    property :bus_distance
    property :bus_duration
    property :bus_path
    property :bus_departure_time
    property :bus_departure_stop_name
    property :bus_arrival_time
    property :bus_arrival_stop_name
    property :bus_num_stops
    property :bus_sub_route_name
  end
end
