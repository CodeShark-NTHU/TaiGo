# frozen_string_literal: false

require 'dry-struct'
require_relative '../motc_mappers/bus_sub_route_mapper.rb'

module TaiGo
  module Entity
    # Domain entity object for git BusRoute
    class BusSubRoute < Dry::Struct
      attribute :id, Types::Strict::String # maybe change to sub_route_id ?
      attribute :route_id, Types::Strict::String
      attribute :name, Types.Instance(TaiGo::MOTC::BusSubRouteMapper::DataMapper::Name)
      attribute :headsign, Types::String.optional
      attribute :direction, Types::Int.optional
    end
  end
end
