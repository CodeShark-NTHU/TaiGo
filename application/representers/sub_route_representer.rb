# frozen_string_literal: true

require_relative 'name_representer'

module TaiGo
  # Representer class for converting BusRoute attributes to json
  class SubRouteRepresenter < Roar::Decorator
    include Roar::JSON

<<<<<<< HEAD
    property :id # maybe change to sub_route_id?
    property :route_id
    property :name # maybe just name? - we must keep some kind of name convension (Reggie)
=======
    property :id
    property :route_id
    property :name
>>>>>>> 5d6f29e31f7ff87d229f33d3ec4de7896bc2fb13
    property :headsign
    property :direction
  end
end
