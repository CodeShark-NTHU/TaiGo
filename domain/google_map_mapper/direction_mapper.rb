# frozen_string_literal: false

module TaiGo
  module GoogleMap
  # Data Mapper for Direction Mapper
    class DirectionMapper
      def initialize(config, gateway = TaiGo::GoogleMap::Api)
        @config = config
        @gateway_class = gateway
        @gateway = @gateway_class.new(@config['GOOGLE_MAP_KEY'].to_s,
                                    @config['GOOGLE_MAP_RETRY_TIMEOUT'].to_i,
                                    @config['GOOGLE_MAP_QUERIES_PER_SECOND'].to_i)
      end
=begin
      def initialize(key, timeout, second)
        gateway = TaiGo::GoogleMap::Api
        # @config = config
        @gateway_class = gateway
        @gateway = @gateway_class.new(key.to_s,
                                      timeout.to_i,
                                      second.to_i)
      end
=end
      def load(start_location, end_location)
        @directions_data = @gateway.direction_data(start_location, end_location)
        load_several(@directions_data)
      end

      def load_several(directions_data)
        # puts "directions_data: #{directions_data.size}"
        results = []
        directions_data.map do |direction_data|
          if available_bus(direction_data)
            results << DirectionMapper.build_entity(direction_data)
          end
        end
        results
      end

      def available_bus(possible_way)
        @has_bus = false
        if possible_way.has_key? :fare
          possible_way[:legs][0][:steps].each do |step|
            if step[:travel_mode] == 'TRANSIT'
              if step[:transit_details][:line][:vehicle][:type] == 'BUS'
                @has_bus = true
              end
            end
          end
        end
        @has_bus
      end

      def self.build_entity(direction_data)
        DataMapper.new(direction_data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          @steps = @data[:legs][0][:steps]
          @walk_array = []
          @bus_array = []
          @steps.each_with_index do |step, index|
            if step[:travel_mode] == 'WALKING'
              walking = Entity::WalkingDirection.new(
                step_no: (index+1),
                walking_distance: walking_distance(step),
                walking_duration: walking_duration(step),
                walkng_instruction: walkng_instruction(step),
                walking_path: walking_path(step),
                walking_start: walking_start(step),
                walking_end: walking_end(step)
              )
              @walk_array << walking
            end
            if step[:travel_mode] == 'TRANSIT'
              bus = Entity::BusDirection.new(
                step_no: (index+1), 
                bus_distance: bus_distance(step),
                bus_duration: bus_duration(step),
                bus_instruction: bus_instruction(step),
                bus_path: bus_path(step),
                bus_departure_time: bus_departure_time(step),
                bus_departure_stop_name: bus_departure_stop_name(step),
                bus_arrival_time: bus_arrival_time(step),
                bus_arrival_stop_name: bus_arrival_stop_name(step),
                bus_num_stops: bus_num_stops(step),
                bus_sub_route_name: bus_sub_route_name(step)
              )
              @bus_array << bus
            end
          end

          Entity::PossibleWay.new(
            total_distance: total_distance,
            total_duration: total_duration,
            total_path: total_path,
            walking_steps: @walk_array,
            bus_steps: @bus_array
          )
        end

        private

        def total_distance
          @data[:legs][0][:distance][:text]
        end

        def total_duration
          @data[:legs][0][:duration][:text]
        end

        def total_path
          @data[:overview_polyline][:points]
        end

        def walking_distance(step)
          step[:distance][:text]
        end

        def walking_duration(step)
          step[:duration][:text]
        end

        def walkng_instruction(step)
          step[:html_instructions]
        end

        def walking_path(step)
          step[:polyline][:points]
        end

        def walking_start(step)
          Coordinates.new(step[:start_location][:lat],
                          step[:start_location][:lng])
        end

        def walking_end(step)
          Coordinates.new(step[:end_location][:lat],
                          step[:end_location][:lng])
        end

        def bus_distance(step)
          step[:distance][:text]
        end

        def bus_duration(step)
          step[:duration][:text]
        end

        def bus_instruction(step)
          step[:html_instructions]
        end

        def bus_path(step)
          step[:polyline][:points]
        end

        def bus_departure_time(step)
          step[:transit_details][:departure_time][:text]
        end

        def bus_departure_stop_name(step)
          step[:transit_details][:departure_stop][:name]
        end

        def bus_arrival_time(step)
          step[:transit_details][:arrival_time][:text]
        end

        def bus_arrival_stop_name(step)
          step[:transit_details][:arrival_stop][:name]
        end

        def bus_num_stops(step)
          step[:transit_details][:num_stops] 
        end

        def bus_sub_route_name(step)
          step[:transit_details][:line][:short_name]
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
=begin
test = TaiGo::GoogleMap::DirectionMapper.new('AIzaSyBjcKDMFDmdZyzd-XjqQADKoaht2UNxNvM',20,10)
# start, end
test.load('新竹火車站(中正路) 300新竹市東區
', '300新竹市東區光復路二段101號')
=end