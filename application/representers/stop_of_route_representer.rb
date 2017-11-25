# frozen_string_literal: true

require_relative 'bus_stop_representer'
# require_relative 'sub_route_representer'

module TaiGo
  # Representer class for converting BusRoute attributes to json
  class StopOfRouteRepresenter < Roar::Decorator
    include Roar::JSON

    property :sub_route_id # maybe change to stop_of_route_id?
    property :stop_id # maybe change to stop_id (consistency)?
    property :stop_boarding
    property :stop_sequence
    property :stop, extend: BusStopRepresenter
  end
end
