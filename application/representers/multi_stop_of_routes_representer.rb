# frozen_string_literal: true

require_relative 'stop_of_routes_representer.rb'
require_relative 'stop_of_route_representer.rb'

module TaiGo
  # Representer class for converting StopOfRoutes attributes to json
  class MultiStopOfRoutesRepresenter < Roar::Decorator
    include Roar::JSON
    collection :multistopofroutes, extend: StopOfRoutesRepresenter
  end
end
