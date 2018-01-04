# frozen_string_literal: true

require_relative 'sub_route_representer.rb'

module TaiGo
  # Representer class for converting SubRoutes attributes to json
  class BusSubRoutesRepresenter < Roar::Decorator
    include Roar::JSON

    collection :subroutes, extend: SubRouteRepresenter
  end
end
