# frozen_string_literal: true

module TaiGo
  # Representer class for converting BusRoute attributes to json
  class SubRouteRepresenter < Roar::Decorator
    include Roar::JSON

    property :sub_route_id
    property :sub_route_id
    property :name
    property :headsign
    property :direction

  end
end
