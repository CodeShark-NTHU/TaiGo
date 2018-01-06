# frozen_string_literal: true

require_relative 'name_representer'

module TaiGo
  # Representer class for converting SubRoute attributes to json
  class SubRouteRepresenter < Roar::Decorator
    include Roar::JSON

    property :id
    property :route_id
    property :name, extend: NameRepresenter
    property :headsign
    property :direction
  end
end
