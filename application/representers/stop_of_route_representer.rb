# frozen_string_literal: true

require_relative 'bus_stop_representer'

module TaiGo
  # Representer class for converting StopOfRoute attributes to json
  class StopOfRouteRepresenter < Roar::Decorator
    include Roar::JSON

    property :sub_route_id
    property :stop_id
    property :stop_boarding
    property :stop_sequence
    property :stop, extend: BusStopRepresenter
  end
end
