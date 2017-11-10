# frozen_string_literal: false

module TaiGo
  # Provides access to Bus Sub Route data
  module MOTC
    # Data Mapper for Bus Sub Route
    class BusSubRouteMapper
      def initialize(gateway)
        @gateway = gateway
      end

      def load_several(bus_routes_data, route_id)
        @sub_routes_data = bus_routes_data
        @route_id = route_id
        @sub_routes_data.map do |sub_route_data|
          BusSubRouteMapper.build_entity(sub_route_data, route_id)
        end
      end

      def self.build_entity(sub_routes_data, route_id)
        DataMapper.new(sub_routes_data, route_id).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(sub_routes_data, route_id)
          @sub_routes_data = sub_routes_data
          @route_id = route_id
        end

        def build_entity
          Entity::BusSubRoute.new(
            sub_route_uid: sub_route_uid,
            route_id: route_id,
            sub_route_name: sub_route_name,
            headsign: headsign,
            direction: direction
          )
        end

        private

        def sub_route_uid
          @sub_routes_data['SubRouteUID']
        end

        def route_id
          @route_id
        end
        
        def sub_route_name
          Name.new(@sub_routes_data['SubRouteName']['En'],
                   @sub_routes_data['SubRouteName']['Zh_tw'])
        end

        def headsign
          @sub_routes_data['Headsign']
        end

        def direction
          @sub_routes_data['Direction']
        end

        # Extract class name
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
