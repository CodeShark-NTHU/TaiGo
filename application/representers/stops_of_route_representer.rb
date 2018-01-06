# frozen_string_literal: true

require_relative 'stop_of_route_representer.rb'

module TaiGo
  # Representer class for converting StopOfRoutes attributes to json
  class StopsOfSubRouteRepresenter < Roar::Decorator
    include Roar::JSON
    property :sub_route_name_ch
    collection :stops_of_sub_route, extend: StopOfRouteRepresenter
  end
end
