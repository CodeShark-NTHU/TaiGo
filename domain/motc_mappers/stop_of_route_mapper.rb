# frozen_string_literal: false

module TaiGo
  # Provides access to Bus Route data
  module MOTC
    # Data Mapper for Bus Route
    class StopOfRouteMapper
      def initialize(config, gateway = TaiGo::MOTC::Api)
        @config = config
        @gateway_class = gateway
        @gateway = @gateway_class.new(@config['MOTC_ID'].to_s,
                                      @config['MOTC_KEY'].to_s)
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
            sub_route_id: sub_route_id,
            stop_id: stop_id,
            stop_boarding: stop_boarding,
            stop_sequence: stop_sequence,
<<<<<<< HEAD
=======
            # sub_route: nil,
>>>>>>> 5d6f29e31f7ff87d229f33d3ec4de7896bc2fb13
            stop: nil
          )
        end

        private

        def sub_route_id
          @stop['SubRouteUID']
        end

        def stop_id
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
