# frozen_string_literal: true

require_relative 'name_representer'

module TaiGo
  # Representer class for converting BusRoute attributes to json
  class SubRouteRepresenter < Roar::Decorator
    include Roar::JSON

    property :sub_route_uid # maybe change to sub_route_id?
    property :route_id
    property :sub_route_name # maybe just name? - we must keep some kind of name convension (Reggie)
    property :headsign
    property :direction
  end
end
