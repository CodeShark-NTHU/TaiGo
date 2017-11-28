# frozen_string_literal: true

require_relative 'bus_position_representer'

module TaiGo
  # Representer class for converting Bus Positions attributes to json
  class BusPositionsRepresenter < Roar::Decorator
    include Roar::JSON

    collection :positions, extend: BusPositionRepresenter
  end
end
