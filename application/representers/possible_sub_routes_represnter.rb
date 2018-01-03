# frozen_string_literal: true

require_relative 'possible_sub_route_represnter.rb'

module TaiGo
  # Representer class for converting Name property to json
  class PossibleSubRoutesRepresenter < Roar::Decorator
    include Roar::JSON
    collection :sub_route_set, extend: PossibleSubRouteRepresenter
  end
end
