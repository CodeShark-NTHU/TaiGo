# frozen_string_literal: true

require_relative 'bus_stop_representer.rb'
require_relative 'stop_of_route_representer.rb'

module TaiGo
  # Representer class for converting Name property to json
  class PossibleSubRouteRepresenter < Roar::Decorator
    include Roar::JSON
    property :start_stop, extend: BusStopRepresenter
    collection :stops_of_sub_route, extend: StopOfRouteRepresenter
  end
end
