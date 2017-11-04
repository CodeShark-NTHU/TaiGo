# frozen_string_literal: false

module TaiGo
  # Provides access to contributor data
  module MOTC
    # Data Mapper for Github contributors
    class RouteStopsMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load_several(route_stops_data)
        route_stops_data.map do |rstop_data|
          RouteStopsMapper.build_entity(rstop_data)
        end
      end

      def self.build_entity(rstop_data)
        DataMapper.new(rstop_data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(rstop_data)
          @rstop_data = rstop_data
        end

        def build_entity
          Entity::RouteStop.new(
            stop_uid: stop_uid,
            stop_id: stop_id,
            stop_name_ch: stop_name_ch,
            stop_name_en: stop_name_en,
            stop_boarding: stop_name_en,
            stop_sequence: stop_name_en,
            stop_latitude: stop_latitude,
            stop_longitude: stop_longitude
          )
        end

        private

        def stop_uid
          @rstop_data['StopUID']
        end

        def stop_id
          @rstop_data['StopID']
        end

        def stop_name_ch
          @rstop_data['StopName']['Zh_tw']
        end

        def stop_name_en
          @rstop_data['StopName']['En']
        end

        def stop_boarding
          @rstop_data['StopBoarding']
        end

        def stop_sequence
          @rstop_data['StopSequence']
        end

        def stop_latitude
          @rstop_data['StopPosition']['PositionLat']
        end

        def stop_longitude
          @rstop_data['StopPosition']['PositionLon']
        end
      end
    end
  end
end
