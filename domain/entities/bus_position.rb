# frozen_string_literal: false

require 'dry-struct'
require_relative '../motc_mappers/bus_position_mapper.rb'

module TaiGo
  module Entity
    # Domain entity object for git BusStop
    class BusPosition < Dry::Struct
      attribute :plate_numb, Types::Strict::String
      attribute :sub_route_id, Types::Strict::String
      attribute :coordinates, Types.Instance(TaiGo::MOTC::BusPositionMapper::DataMapper::Coordinates)
      attribute :speed, Types::Strict::Int.optional
      attribute :azimuth, Types::Strict::Int.optional
      attribute :duty_status, Types::Strict::String.optional
      attribute :bus_status, Types::Strict::String.optional
    end
  end
end
