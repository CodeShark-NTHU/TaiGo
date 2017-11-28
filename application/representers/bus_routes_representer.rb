# frozen_string_literal: true

require_relative 'bus_route_representer'

module TaiGo
  # Representer class for converting BusRoutes attributes to json
  class BusRoutesRepresenter < Roar::Decorator
    include Roar::JSON

    collection :routes, extend: BusRouteRepresenter
  end
end
