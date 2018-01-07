# frozen_string_literal: false

module TaiGo
  # Provides access to bus stop data
  module MOTC
    # Data Mapper for Bus Stop Mapper
    class BusStopMapper
      def initialize(config, gateway = TaiGo::MOTC::Api)
        @config = config
        @gateway_class = gateway
        @gateway = @gateway_class.new(@config['MOTC_ID'].to_s,
                                      @config['MOTC_KEY'].to_s)
      end

      def load(city_name)
        @city_bus_stops_data = @gateway.city_bus_stops_data(city_name)
        load_several(@city_bus_stops_data, city_name)
      end

      def load_several(city_bus_stops_data, city_name)
        city_bus_stops_data.map do |bus_stop_data|
          BusStopMapper.build_entity(bus_stop_data, city_name)
        end
      end

      def self.build_entity(bus_stop_data, city_name)
        DataMapper.new(bus_stop_data, city_name).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, city_name)
          @data = data
          @city_name = city_name
        end

        def build_entity
          Entity::BusStop.new(
            id: id,
            authority_id: authority_id,
            name: name,
            coordinates: coordinates,
            city_name: city_name,
            address: address
          )
        end

        private

        def id
          @data['StopUID']
        end

        def authority_id
          @data['AuthorityID']
        end

        def address
          @data['Address']
        end

        def name
          Name.new(@data['StopName']['En'],
                   @data['StopName']['Zh_tw'])
        end

        def coordinates
          Coordinates.new(@data['StopPosition']['PositionLat'],
                          @data['StopPosition']['PositionLon'])
        end

        attr_reader :city_name
        # this is a helper class for name
        class Name
          attr_reader :english, :chinese

          def initialize(en, ch)
            @english = en
            @chinese = ch
          end
        end

        # this is a helper class for coordinates
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
