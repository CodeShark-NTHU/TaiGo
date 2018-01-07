# frozen_string_literal: false

require 'dry-struct'

module TaiGo
  module Entity
    # Domain entity object for PossibleWay
    class PossibleWay < Dry::Struct
      attribute :total_distance, Types::Strict::String
      attribute :total_duration, Types::Strict::String
      attribute :total_path, Types::Strict::Array.member(Types.Instance(TaiGo::GoogleMap::DirectionMapper::DataMapper::Coordinates))
      attribute :walking_steps, Types::Array
      attribute :bus_steps, Types::Array
    end
  end
end
