# frozen_string_literal: false

module TaiGo
  # Provides access to Bus Route data
  module MOTC
    # Data Mapper for Bus Route
    class StopOfRouteMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(city_name)
        @stop_of_route_data = @gateway.city_stop_route_data(city_name)
        @temp_hash = []
        @new_data = change_data_format(@stop_of_route_data)
        load_several(@new_data)
      end

      def change_data_format(stop_of_route_data)
        stop_of_route_data.map do |bus_route_data|
          route_id = bus_route_data['RouteUID']
          sub_route_id = bus_route_data['SubRouteUID']
          direction = bus_route_data['Direction']
          bus_stop(bus_route_data['Stops'], route_id, sub_route_id, direction)
        end
        @temp_hash
      end

      def bus_stop(data, route_id, sub_route_id, direction)
        data.map do |stop|
          stop['RouteUID'] = route_id
          stop['SubRouteUID'] = sub_route_id
          stop['Direction'] = direction
          @temp_hash << stop
        end
      end

      def load_several(stop_of_route_data)
        stop_of_route_data.map do |stop|
          StopOfRouteMapper.build_entity(stop)
        end
      end

      def self.build_entity(stop)
        DataMapper.new(stop).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(stop)
          @stop = stop
        end

        def build_entity
          Entity::StopOfRoute.new(
            route_uid: route_uid,
            sub_route_id: sub_route_uid,
            direction: direction,
            stop_uid: stop_uid,
            stop_boarding: stop_boarding,
            stop_sequence: stop_sequence
          )
        end

        private

        def route_uid
          @stop['RouteUID']
        end

        def sub_route_uid
          @stop['SubRouteUID']
        end

        def direction
          @stop['Direction']
        end

        def stop_uid
          @stop['StopUID']
        end

        def stop_boarding
          @stop['StopBoarding']
        end

        def stop_sequence
          @stop['StopSequence']
        end
      end
    end
  end
end
