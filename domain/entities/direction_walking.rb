# frozen_string_literal: false

require 'dry-struct'
require_relative '../google_map_mapper/direction_mapper.rb'

module TaiGo
  module Entity
    # Domain entity object for WalkingDirection
    class WalkingDirection < Dry::Struct
      attribute :step_no, Types::Strict::Int
      attribute :walking_distance, Types::Strict::String
      attribute :walking_duration, Types::Strict::String
      attribute :walkng_instruction, Types::Strict::String
      attribute :walking_path, Types::Strict::String
      attribute :walking_start, Types.Instance(TaiGo::GoogleMap::DirectionMapper::DataMapper::Coordinates)
      attribute :walking_end, Types.Instance(TaiGo::GoogleMap::DirectionMapper::DataMapper::Coordinates)
    end
  end
end
