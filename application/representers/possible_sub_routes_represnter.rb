# frozen_string_literal: true

require_relative 'bus_stop_representer.rb'
require_relative 'possible_sub_route_represnter.rb'

module TaiGo
  # Representer class for converting Name property to json
  class PossibleSubRoutesRepresenter < Roar::Decorator
    include Roar::JSON
    property :destination_stop, extend: BusStopRepresenter
    collection :sub_route_set, extend: PossibleSubRouteRepresenter
  end
end
