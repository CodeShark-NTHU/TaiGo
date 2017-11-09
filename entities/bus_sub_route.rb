# frozen_string_literal: false

require 'dry-struct'
require_relative '../lib/mapper/bus_sub_route_mapper.rb'

module TaiGo
  module Entity
    # Domain entity object for git BusRoute
    class BusSubRoute < Dry::Struct
      attribute :sub_route_uid, Types::Strict::String
      attribute :sub_route_name, Types.Instance(TaiGo::MOTC::BusSubRouteMapper::DataMapper::Name)
      attribute :headsign, Types::String.optional
      attribute :direction, Types::Int.optional
    end
  end
end
