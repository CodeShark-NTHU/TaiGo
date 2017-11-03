# frozen_string_literal: false

# require_relative '../motc_api.rb'
# require_relative '../../entities/init.rb'
# require_relative '../../entities/bus_route.rb'

module TaiGo
  # Provides access to contributor data
  module MOTC
    # Data Mapper for Github contributors
    class BusRouteMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load(city_name)
        @city_bus_route_data = @gateway.city_bus_route_data(city_name)
        load_several(@city_bus_route_data)
      end

      def load_several(city_bus_route_data)
        city_bus_route_data.map do |bus_route_data|
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
        end

        def build_entity
          Entity::BusRoute.new(
            route_uid: route_uid,
            route_name_zh: route_name_zh,
            route_name_en: route_name_en,
            authority_id: authority_id,
            depart_stop_name_zh: depart_stop_name_zh,
            depart_stop_name_en: depart_stop_name_en,
            dest_stop_name_zh: dest_stop_name_zh,
            dest_stop_name_en: dest_stop_name_en
          )
        end

        private

        def route_uid
          @bus_route_data['RouteUID']
        end

        def route_name_zh
          @bus_route_data['RouteName']['Zh_tw']
        end

        def route_name_en
          @bus_route_data['RouteName']['En']
        end

        def authority_id
          @bus_route_data['AuthorityID']
        end

        def depart_stop_name_zh
          @bus_route_data['DepartureStopNameZh']
        end

        def depart_stop_name_en
          @bus_route_data['DepartureStopNameEn']
        end

        def dest_stop_name_zh
          @bus_route_data['DestinationStopNameZh']
        end

        def dest_stop_name_en
          @bus_route_data['DestinationStopNameEn']
        end
      end
    end
  end
end
