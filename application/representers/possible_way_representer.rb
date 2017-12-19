# frozen_string_literal: true

require_relative 'walking_direction_representer'
require_relative 'bus_direction_representer'

module TaiGo
  # Representer class for converting Bus Position attributes to json
  class PossibleWayRepresenter < Roar::Decorator
    include Roar::JSON

    property :total_distance
    property :total_duration
    property :total_path
    collection :walking_steps, extend: WalkingDirectionRepresenter
    collection :bus_steps, extend: BusDirectionRepresenter
  end
end
