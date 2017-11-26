# frozen_string_literal: true

require_relative 'bus_position_representer'

# Represents essential Bus Position information for API output
module TaiGo
  class BusPositionsRepresenter < Roar::Decorator
    include Roar::JSON

    collection :positions, extend: BusPositionRepresenter
  end
end
