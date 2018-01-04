# frozen_string_literal: true

require_relative 'coordinate_representer.rb'

module TaiGo
  # Representer class for converting Bus Position attributes to json
  class BusPositionRepresenter < Roar::Decorator
    include Roar::JSON

    property :plate_numb
    property :sub_route_id
    property :coordinates, extend: CoordinateRepresenter, class: OpenStruct
    property :speed
    property :azimuth
    property :duty_status
    property :bus_status
  end
end
