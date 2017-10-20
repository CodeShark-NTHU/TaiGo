# frozen_string_literal: false

require_relative 'bus_stop.rb'

module PublicTransporation
  # Model for City
  class CityStops
    def initialize(city_data, data_source)
      @city = city_data
      @data_source = data_source
    end

    def size
      @size ||= @city.count
    end

    def authority_id
      @authority_id ||= @city[0]['AuthorityID']
    end

    def bus_stops
      @bus_stops ||= @data_source.stop_list(@city)
    end
  end
end
