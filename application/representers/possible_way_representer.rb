# frozen_string_literal: true

require_relative 'walking_direction_representer'
require_relative 'bus_direction_representer'
require_relative 'coordinate_representer'
require_relative 'stops_of_route_representer'

module TaiGo
  # Representer class for converting Bus Position attributes to json
  class PossibleWayRepresenter < Roar::Decorator
    include Roar::JSON

    property :total_distance
    property :total_duration
    collection :total_path, extend: CoordinateRepresenter, class: OpenStruct
    collection :walking_steps, extend: WalkingDirectionRepresenter
    collection :bus_steps, extend: BusDirectionRepresenter
    # collection :stops_of_sub_routes, extend: StopsOfRouteRepresenter
  end
end
