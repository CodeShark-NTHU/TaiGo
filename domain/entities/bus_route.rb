# frozen_string_literal: false

require 'dry-struct'
require_relative '../motc_mappers/bus_route_mapper.rb'
require_relative 'bus_sub_route.rb'

module TaiGo
  module Entity
    # Domain entity object for BusRoute
    class BusRoute < Dry::Struct
      attribute :id, Types::Strict::String
      attribute :name, Types.Instance(TaiGo::MOTC::BusRouteMapper::DataMapper::Name)
      attribute :depart_name, Types.Instance(TaiGo::MOTC::BusRouteMapper::DataMapper::Name).optional
      attribute :destination_name, Types.Instance(TaiGo::MOTC::BusRouteMapper::DataMapper::Name).optional
      attribute :authority_id, Types::String.optional
      attribute :city_name, Types::String.optional
      attribute :sub_routes, Types::Strict::Array.member(BusSubRoute).optional
    end
  end
end
