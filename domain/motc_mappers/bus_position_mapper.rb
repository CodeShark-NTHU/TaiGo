# frozen_string_literal: false

module TaiGo
  # Provides access to MOTC Bus Real Time Position Data
  module MOTC
    # Data Mapper for Bus Position Mapper
    class BusPositionMapper
      def initialize(config, gateway = TaiGo::MOTC::Api)
        @config = config
        @gateway_class = gateway
        @gateway = @gateway_class.new(@config['MOTC_ID'].to_s,
                                      @config['MOTC_KEY'].to_s)
      end

      def load(city_name, route_name)
        @city_bus_position_data = @gateway.city_bus_position_data(city_name,
                                                                  route_name)
        load_several(@city_bus_position_data)
      end

      def load_several(city_bus_position_data)
        city_bus_position_data.map do |bus_position_data|
          BusPositionMapper.build_entity(bus_position_data)
        end
      end

      def self.build_entity(bus_position_data)
        DataMapper.new(bus_position_data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::BusPosition.new(
            plate_numb: plate_numb,
            sub_route_id: sub_route_id,
            coordinates: coordinates,
            sub_route_name: sub_route_name,
            speed: speed,
            azimuth: azimuth,
            duty_status: duty_status,
            bus_status: bus_status
          )
        end

        private

        def plate_numb
          @data['PlateNumb']
        end

        def sub_route_id
          @data['SubRouteUID']
        end

        def coordinates
          Coordinates.new(@data['BusPosition']['PositionLat'],
                          @data['BusPosition']['PositionLon'])
        end

        def sub_route_name
          Name.new(@data['SubRouteName']['En'],
                   @data['SubRouteName']['Zh_tw'])
        end

        def speed
          @data['Speed']
        end

        def azimuth
          @data['Azimuth']
        end

        def duty_status
          @data['DutyStatus']
        end

        def bus_status
          @data['BusStatus']
        end

        # this is a helper class for coordinates
        class Coordinates
          attr_reader :latitude, :longitude

          def initialize(lat, long)
            @latitude = lat
            @longitude = long
          end
        end

        # this is a helper class for Name
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
