# frozen_string_literal: true

require_relative 'stop_of_route_representer.rb'

module TaiGo
  # Representer class for converting StopOfRoutes attributes to json
  class StopOfRoutesRepresenter < Roar::Decorator
    include Roar::JSON

    collection :stopofroutes, extend: StopOfRouteRepresenter
  end
end
