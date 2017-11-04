# frozen_string_literal: false

require_relative 'route_stops_mapper.rb'

module TaiGo
  # Provides access to Stop of Routes data
  module MOTC
    # Data Mapper for Stop of Routes
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
          StopOfRouteMapper.build_entity(bus_route_data)
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
          Entity::BusRoute.new(
            route_uid: route_uid,
            sub_route_uid: sub_route_uid,
            route_name: route_name,
            depart_name: depart_name,
            destination_name: destination_name,
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

        def route_name
          Name.new(@bus_route_data['RouteName']['En'],
                   @bus_route_data['RouteName']['Zh_tw'])
        end

        def depart_name
          Name.new(@bus_route_data['DepartureStopNameEn'],
                   @bus_route_data['DepartureStopNameZh'])
        end

        def destination_name
          Name.new(@bus_route_data['DestinationStopNameEn'],
                   @bus_route_data['DestinationStopNameZh'])
        end

        def stops
          @route_stops_mappper.load_several(@bus_route_data['Stops'])
        end

        # Extract the class for name
        class Name
          attr_reader :english, :chinese

          def initialize(en, ch)
            @english = en
            @chinese = ch
          end
        end
      end
    end
  end
end
