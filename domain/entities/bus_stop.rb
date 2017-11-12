# frozen_string_literal: false

require 'dry-struct'
require_relative '../motc_mappers/bus_stop_mapper.rb'

module TaiGo
  module Entity
    # Domain entity object for git BusStop
    class BusStop < Dry::Struct
      attribute :uid, Types::Strict::String # maybe change this to stop_id?
      attribute :name, Types.Instance(TaiGo::MOTC::BusStopMapper::DataMapper::Name) # maybe change to stop_name for consistency? 
      attribute :coordinates, Types.Instance(TaiGo::MOTC::BusStopMapper::DataMapper::Coordinates)
      attribute :authority_id, Types::Strict::String
      attribute :address, Types::Strict::String.optional
    end
  end
end
