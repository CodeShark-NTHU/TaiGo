# frozen_string_literal: true

require_relative 'coordinate_representer'

module TaiGo
  # Representer class for converting WalkingDirection attributes to json
  class WalkingDirectionRepresenter < Roar::Decorator
    include Roar::JSON
    property :step_no
    property :walking_distance
    property :walking_duration
    property :walkng_instruction
    collection :walking_path, extend: CoordinateRepresenter, class: OpenStruct
    property :walking_start, extend: CoordinateRepresenter, class: OpenStruct
    property :walking_end, extend: CoordinateRepresenter, class: OpenStruct
  end
end

