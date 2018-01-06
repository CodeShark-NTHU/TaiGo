# frozen_string_literal: true

# Represents essential RealTimeBus information for service real_time_motc_positions_of_sub_route
module TaiGo
  class RealTimeBusRequestRepresenter < Roar::Decorator
    include Roar::JSON

    property :city_name
    property :route_name
    property :id
  end
end
