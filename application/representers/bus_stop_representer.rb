# frozen_string_literal: true

require_relative 'name_representer.rb'
require_relative 'coordinate_representer.rb'

module TaiGo
  # Representer class for converting BusRoute attributes to json
  class BusStopRepresenter < Roar::Decorator
    include Roar::JSON

<<<<<<< HEAD
    property :id 
=======
    property :id
>>>>>>> 5d6f29e31f7ff87d229f33d3ec4de7896bc2fb13
    property :name, extend: NameRepresenter
    property :coordinates, extend: CoordinateRepresenter
    property :authority_id
  end
end
