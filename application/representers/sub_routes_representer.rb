# frozen_string_literal: true

require_relative 'name_representer.rb'
require_relative 'coordinate_representer.rb'

module TaiGo
  # Representer class for converting BusRoute attributes to json
  class BusSubRoutesRepresenter < Roar::Decorator
    include Roar::JSON

    collection :subroutes, extend: SubRouteRepresenter
  end
end
