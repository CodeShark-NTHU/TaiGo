# frozen_string_literal: true
# frozen_string_literal: false

require_relative 'bus_stop_representer'

module TaiGo
  # Representer class for converting BusRoute attributes to json
  class StopOfRoutesRepresenter < Roar::Decorator
    include Roar::JSON

    collection :stopofroutes, extend: StopOfRouteRepresenter
  end
end
