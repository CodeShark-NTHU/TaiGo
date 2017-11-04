# frozen_string_literal: false

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
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::BusStop.new(
            uid: uid,
            authority_id: authority_id,
            name: name,
            coordinates: coordinates,
            address: address
          )
        end

        private

        def uid
          @data['StopUID']
        end

        def authority_id
          @data['AuthorityID']
        end

        def name
          Name.new(@data['StopName']['En'],@data['StopName']['Zh_tw'])
        end

        def coordinates
          Coordinates.new(@data['StopPosition']['PositionLat'],@data['StopPosition']['PositionLon'])
        end

        def address
          @data['stop_address']
        end

        class Name 
          attr_reader :english, :chinese
  
          def initialize(en,ch)
            @english = en
            @chinese = ch
          end
        end
  
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
