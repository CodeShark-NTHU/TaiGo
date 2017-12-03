# frozen_string_literal: true

require_relative 'name_representer.rb'
require_relative 'coordinate_representer.rb'

module TaiGo
  # Representer class for converting BusStops attributes to json
  class BusStopsRepresenter < Roar::Decorator
    include Roar::JSON

    collection :stops, extend: BusStopRepresenter
  end
end
