# frozen_string_literal: false

module TaiGo
  # Provides access to Route Stops data
  module MOTC
    # Data Mapper for Github Route Stops
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
          Entity::BusStop.new(
            uid: uid,
            name: name,
            coordinates: coordinates,
            address: address,
            sequence: sequence,
            boarding: boarding
          )
        end

        private

        def uid
          @data['StopUID']
        end

        def name
          Name.new(@data['StopName']['En'],
                   @data['StopName']['Zh_tw'])
        end

        def coordinates
          Coordinates.new(@data['StopPosition']['PositionLat'],
                          @data['StopPosition']['PositionLon'])
        end

        def address
          @data['stop_address']
        end

        def sequence
          @data['StopSequence']
        end

        def boarding
          @data['StopBoarding']
        end

        # Extract class Name
        class Name
          attr_reader :english, :chinese

          def initialize(en, ch)
            @english = en
            @chinese = ch
          end
        end

        # Extract class Coordinates
        class Coordinates
          attr_reader :latitude, :longitude

          def initialize(lat, long)
            @latitude = lat
            @longitude = long
          end
        end
      end
    end
  end
end
