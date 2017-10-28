# frozen_string_literal: false

require_relative 'bus_stop_mapper.rb'

module TaiGo
  module MOTC
    # Data Mapper object for MOTC's city bus stops info
    class CityBusStopsMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(city_name)
        city_bus_stops_data = @gateway.city_bus_stops_data(city_name)
        build_entity(city_bus_stops_data)
      end

      def build_entity(city_bus_stops_data)
        DataMapper.new(city_bus_stops_data, @gateway).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(city_bus_stops_data, gateway)
          @city_bus_stops_data = city_bus_stops_data
          @bus_stop_mapper = BusStopMapper.new(gateway)
        end

        def build_entity
          TaiGo::Entity::CityBusStops.new(
            bus_stops: bus_stops
          )
        end

        def bus_stops
          @bus_stop_mapper.load_several(@city_bus_stops_data)
        end
      end
    end
  end
end


