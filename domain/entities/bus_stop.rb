# frozen_string_literal: false

require 'dry-struct'
require_relative '../motc_mappers/bus_stop_mapper.rb'

module TaiGo
  module Entity
    # Domain entity object for BusStop
    class BusStop < Dry::Struct
      attribute :id, Types::Strict::String
      attribute :name, Types.Instance(TaiGo::MOTC::BusStopMapper::DataMapper::Name)
      attribute :coordinates, Types.Instance(TaiGo::MOTC::BusStopMapper::DataMapper::Coordinates)
      attribute :authority_id, Types::Strict::String
      attribute :address, Types::Strict::String.optional
    end
  end
end
