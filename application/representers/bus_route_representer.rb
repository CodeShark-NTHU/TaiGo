# frozen_string_literal: true

require_relative 'name_representer'
require_relative 'sub_route_representer'

module TaiGo
  # Representer class for converting BusRoute attributes to json
  class BusRouteRepresenter < Roar::Decorator
    include Roar::JSON

    property :route_uid # maybe change to route_id?
    property :route_name, extend: NameRepresenter # maybe change to name?
    property :depart_name, extend: NameRepresenter
    property :destination_name, extend: NameRepresenter
    property :authority_id
    #collection :sub_routes, extend: SubRouteRepresenter

  end
end
