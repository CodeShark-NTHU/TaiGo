# frozen_string_literal: true

module TaiGo
  # Representer class for converting BusRoute attributes to json
  class CoordinateRepresenter < Roar::Decorator
    include Roar::JSON

    property :latitude 
    property :longitude

  end
end