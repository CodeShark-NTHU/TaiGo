# frozen_string_literal: true

require_relative 'name_representer.rb'
require_relative 'coordinate_representer.rb'

module TaiGo
  # Representer class for converting BusRoute attributes to json
  class BusStopRepresenter < Roar::Decorator
    include Roar::JSON

    property :id # maybe change this to stop_id?
    property :name, extend: NameRepresenter # maybe change to stop_name for consistency? 
    property :coordinates, extend: CoordinateRepresenter
    property :authority_id

  end
end