# frozen_string_literal: true

require_relative 'bus_route_representer'

# Represents essential Repo information for API output
module TaiGo
  class BusRoutesRepresenter < Roar::Decorator
    include Roar::JSON

    collection :routes, extend: BusRouteRepresenter
  end
end
