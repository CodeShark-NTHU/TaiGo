# frozen_string_literal: false

# require_relative '../motc_api.rb'
# require_relative '../../entities/init.rb'
# require_relative '../../entities/bus_stop.rb'

module TaiGo
  # Provides access to contributor data
  module MOTC
    # Data Mapper for Github contributors
    class BusStopMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(city_name)
        @city_bus_stops_data = @gateway.city_bus_stops_data(city_name)
        load_several(@city_bus_stops_data)
      end

      def load_several(city_bus_stops_data)
        city_bus_stops_data.map do |bus_stop_data|
          BusStopMapper.build_entity(bus_stop_data)
        end
      end

      def self.build_entity(bus_stop_data)
        DataMapper.new(bus_stop_data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(bus_stop_data)
          @bus_stop_data = bus_stop_data
        end

        def build_entity
          Entity::BusStop.new(
            uid: uid,
            authority_id: authority_id,
            stop_name_ch: stop_name_ch,
            stop_name_en: stop_name_en,
            stop_latitude: stop_latitude,
            stop_longitude: stop_longitude,
            stop_address: stop_address
          )
        end

        private

        def uid
          @bus_stop_data['StopUID']
        end

        def authority_id
          @bus_stop_data['AuthorityID']
        end

        def stop_name_ch
          @bus_stop_data['StopName']['Zh_tw']
        end

        def stop_name_en
          @bus_stop_data['StopName']['En']
        end

        def stop_latitude
          @bus_stop_data['StopPosition']['PositionLat']
        end

        def stop_longitude
          @bus_stop_data['StopPosition']['PositionLon']
        end

        def stop_address
          @bus_stop_data['stop_address']
        end
      end
    end
  end
end
