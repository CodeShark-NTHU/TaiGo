# frozen_string_literal: false

require 'dry-struct'
require_relative '../lib/mapper/bus_route_mapper.rb'

module TaiGo
  module Entity
    # Domain entity object for git BusRoute
    class BusRoute < Dry::Struct
      attribute :route_uid, Types::Strict::String
      attribute :authority_id, Types::Strict::String
      attribute :route_name, Types.Instance(TaiGo::MOTC::BusRouteMapper::DataMapper::Name)
      attribute :depart_name,Types.Instance(TaiGo::MOTC::BusRouteMapper::DataMapper::Name)
      attribute :destination_name, Types.Instance(TaiGo::MOTC::BusRouteMapper::DataMapper::Name)
    end
  end
end
