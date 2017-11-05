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
        load_several(@stop_of_route_data)
      end

      def load_several(stop_of_route_data)
        stop_of_route_data.map do |bus_route_data|
          load_several_bus_stop(bus_route_data)
        end
      end

      def load_several_bus_stop(bus_route_data)
        uid = bus_route_data['RouteUID']
        suid = bus_route_data['SubRouteUID']
        dir = bus_route_data['Direction']
        bus_route_data['Stops'].map do |stop|
          StopOfRouteMapper.build_entity(uid, suid, dir, stop)
        end
      end

      def self.build_entity(uid, suid, dir, stop)
        DataMapper.new(uid, suid, dir, stop).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(uid, suid, dir, stop)
          @uid = uid
          @suid = suid
          @dir = dir
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
          @uid
        end

        def sub_route_uid
          @suid
        end

        def direction
          @dir
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
