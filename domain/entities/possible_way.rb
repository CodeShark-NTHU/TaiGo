# frozen_string_literal: false

require 'dry-struct'

module TaiGo
  module Entity
    # Domain entity object for PossibleWay
    class PossibleWay < Dry::Struct
      attribute :total_distance, Types::Strict::String
      attribute :total_duration, Types::Strict::String
      attribute :total_path, Types::Strict::String
      # attribute :steps, Types::Array
      attribute :walking_steps, Types::Array
      attribute :bus_steps, Types::Array
    end
  end
end
