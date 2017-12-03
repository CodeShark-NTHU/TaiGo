# frozen_string_literal: true

require_relative 'name_representer.rb'
require_relative 'coordinate_representer.rb'

module TaiGo
  # Representer class for converting BusStop attributes to json
  class BusStopRepresenter < Roar::Decorator
    include Roar::JSON

    property :id
    property :name, extend: NameRepresenter
    property :coordinates, extend: CoordinateRepresenter
    property :authority_id
    property :city_name
  end
end
