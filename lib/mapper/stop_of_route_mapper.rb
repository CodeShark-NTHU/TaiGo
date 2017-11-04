# frozen_string_literal: false

require_relative 'route_stops_mapper.rb'

module TaiGo
  # Provides access to contributor data
  module MOTC
    # Data Mapper for Github contributors
    class StopOfRouteMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(city_name)
        @city_stop_of_route_data = @gateway.city_stop_of_route_data(city_name)
        load_several(@city_stop_of_route_data)
      end

      def load_several(city_stop_of_route_data)
        city_stop_of_route_data.map do |bus_route_data|
          BusRouteMapper.build_entity(bus_route_data)
        end
      end

      def self.build_entity(bus_route_data)
        DataMapper.new(bus_route_data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(bus_route_data)
          @bus_route_data = bus_route_data
          @route_stops_mappper = RoutesStopsMapper.new(gateway)
        end

        def build_entity
          Entity::StopOfRoute.new(
            route_uid: route_uid,
            sub_route_uid: sub_route_uid,
            direction: direction,
            stops: stops
          )
        end

        private

        def route_uid
          @bus_route_data['RouteUID']
        end

        def sub_route_uid
          @bus_route_data['SubRouteUID']
        end

        def direction
          @bus_route_data['Direction']
        end

        def stops
          @route_stops_mappper.load_several(@bus_route_data['Stops'])
        end
      end
    end
  end
end
