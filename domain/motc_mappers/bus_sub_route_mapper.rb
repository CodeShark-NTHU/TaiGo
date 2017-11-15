# frozen_string_literal: false

module TaiGo
  # Provides access to Bus Sub Route data
  module MOTC
    # Data Mapper for Bus Sub Route
    class BusSubRouteMapper
      def initialize(config, gateway = TaiGo::MOTC::Api)
        @config = config
        @gateway_class = gateway
        @gateway = @gateway_class.new(@config['MOTC_ID'].to_s,
                                      @config['MOTC_KEY'].to_s)
      end

      def load(city_name)
        @sub_route_data = @gateway.city_bus_route_data(city_name)
        @temp_hash = []
        @new_data = change_data_format(@sub_route_data)
        load_several(@new_data)
      end

      def change_data_format(sub_route_data)
        sub_route_data.map do |sub_route|
          route_id = sub_route['RouteUID']
          sub_route(sub_route['SubRoutes'], route_id)
        end
        @temp_hash
      end

      def sub_route(data, route_id)
        data.map do |subr|
          subr['RouteUID'] = route_id
          @temp_hash << subr
        end
      end

      def load_several(sub_routes_data)
        @sub_routes_data = sub_routes_data
        @sub_routes_data.map do |sub_route|
          BusSubRouteMapper.build_entity(sub_route)
        end
      end

      def self.build_entity(sub_route)
        DataMapper.new(sub_route).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(sub_route)
          @sub_route = sub_route
        end

        def build_entity
          Entity::BusSubRoute.new(
            id: id,
            route_id: route_id,
            name: name,
            headsign: headsign,
            direction: direction, 
            owned_stop_of_routes: []
          )
        end

        private

        def id
          @sub_route['SubRouteUID']
        end

        def route_id
          @sub_route['RouteUID']
        end

        def name
          Name.new(@sub_route['SubRouteName']['En'],
                   @sub_route['SubRouteName']['Zh_tw'])
        end

        def headsign
          @sub_route['Headsign']
        end

        def direction
          @sub_route['Direction']
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
